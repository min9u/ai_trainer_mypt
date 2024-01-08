import 'dart:io';
import 'package:ai_trainer_mypt/theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class CameraView extends StatefulWidget {
  CameraView(
      {Key? key,
      required this.customPaint,
      required this.onImage,
      this.onCameraFeedReady,
      this.onDetectorViewModeChanged,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.back})
      : super(key: key);

  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final VoidCallback? onCameraFeedReady;
  final VoidCallback? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView>
    with SingleTickerProviderStateMixin {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  bool _changingCameraLens = false;

  // 내가 만든거
  bool isExerciseStarted = false;
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 2), // 변경: 화면 아래로 나가도록 수정
    ).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: animationController,
    ));

    _initialize();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _liveFeedBody(),
    );
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
    return Container(
      color: Colors.white,
      child: Stack(
        // fit: StackFit.expand,
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Center(
            child: _changingCameraLens
                ? Center(
                    child: const Text('Changing camera lens'),
                  )
                // : Center(child: const Text('디자인'))
                // 디자인을 위해 잠시 각주
                : CameraPreview(
                    _controller!,
                    child: widget.customPaint,
                  ),
          ),
          _startStopButton(),
          _feedbackText(),
          _settingIconToggle(),
          _switchLiveCameraToggle(),
          // 아래는 mordalBarrier. 새로 추가되는 위젯은 이 위에 추가
          if (animationController.status == AnimationStatus.dismissed)
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
          _precautionsContainer(),
        ],
      ),
    );
  }

  Widget _backButton() => Positioned(
        top: 40,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: Colors.black54,
            child: Icon(
              Icons.arrow_back_ios_outlined,
              size: 20,
            ),
          ),
        ),
      );

  Widget _detectionViewModeToggle() => Positioned(
        bottom: 8,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: widget.onDetectorViewModeChanged,
            backgroundColor: Colors.black54,
            child: Icon(
              Icons.photo_library_outlined,
              size: 25,
            ),
          ),
        ),
      );

  Widget _zoomControl() => Positioned(
        bottom: 16,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Slider(
                    value: _currentZoomLevel,
                    min: _minAvailableZoom,
                    max: _maxAvailableZoom,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: (value) async {
                      setState(() {
                        _currentZoomLevel = value;
                      });
                      await _controller?.setZoomLevel(value);
                    },
                  ),
                ),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        '${_currentZoomLevel.toStringAsFixed(1)}x',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _exposureControl() => Positioned(
        top: 40,
        right: 8,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 250,
          ),
          child: Column(children: [
            Container(
              width: 55,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '${_currentExposureOffset.toStringAsFixed(1)}x',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RotatedBox(
                quarterTurns: 3,
                child: SizedBox(
                  height: 30,
                  child: Slider(
                    value: _currentExposureOffset,
                    min: _minAvailableExposureOffset,
                    max: _maxAvailableExposureOffset,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: (value) async {
                      setState(() {
                        _currentExposureOffset = value;
                      });
                      await _controller?.setExposureOffset(value);
                    },
                  ),
                ),
              ),
            )
          ]),
        ),
      );

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        _currentZoomLevel = value;
        _minAvailableZoom = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        _maxAvailableZoom = value;
      });
      _currentExposureOffset = 0.0;
      _controller?.getMinExposureOffset().then((value) {
        _minAvailableExposureOffset = value;
      });
      _controller?.getMaxExposureOffset().then((value) {
        _maxAvailableExposureOffset = value;
      });
      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  // 내가 만든 위젯

  Widget _settingIconToggle() => Positioned(
        top: 30,
        right: 10,
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.settings,
            size: 30,
          ),
        ),
      );

  Widget _switchLiveCameraToggle() => Positioned(
      top: 30,
      left: 10,
      child: IconButton(
        onPressed: () {},
        icon: Icon(
            Platform.isIOS
                ? Icons.flip_camera_ios_outlined
                : Icons.flip_camera_android_outlined,
            size: 30),
      ));

  Widget _feedbackText() => Positioned(
        bottom: 140,
        right: 20,
        child: Container(
          width: 170,
          height: 150,
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                '완전 이완 : O',
                style: AppTheme.textTheme.bodyMedium,
              ),
              Text(
                '완전 수축 : X',
                style: AppTheme.textTheme.bodyMedium,
              ),
              Text(
                '무릎 골반 동시수축 : O',
                style: AppTheme.textTheme.bodyMedium,
              ),
              Text(
                '무릎의 균형 : O',
                style: AppTheme.textTheme.bodyMedium,
              ),
              Text(
                '운동수행속도 : X',
                style: AppTheme.textTheme.bodyMedium,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(120, 120, 120, 0.5),
              borderRadius: BorderRadius.all(Radius.circular(30))),
        ),
      );

  Widget _startStopButton() => Positioned(
        bottom: 20,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (!isExerciseStarted) {
                isExerciseStarted = !isExerciseStarted;
              } else {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    backgroundColor: AppTheme.chipBackground,
                    title: const Text(
                      '운동을 중지하시겠습니까?',
                      style: AppTheme.titleMedium,
                    ),
                    content: const Text('운동을 중지하고 운동분석결과를 확인합니다.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/exerciseResult');
                        },
                        child: const Text('확인'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('취소'),
                      ),
                    ],
                  ),
                );
              }
            });
          },
          child: AnimatedContainer(
            alignment: Alignment.center,
            child: isExerciseStarted
                ? Icon(
                    Icons.stop_rounded,
                    color: Color.fromRGBO(83, 189, 113, 0),
                    size: 40,
                  ) // 텍스트가 없어지도록 함
                : Text(
                    '운동 시작',
                    style: AppTheme.whiteTitle,
                  ),
            width: isExerciseStarted
                ? 60
                : MediaQuery.of(context).size.width * 0.8,
            height: 60,
            decoration: isExerciseStarted
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(30), right: Radius.circular(30)),
                    border: Border.all(
                        width: 2, color: Color.fromRGBO(82, 201, 115, 1)))
                : BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(82, 201, 115, 1),
                        Color.fromRGBO(77, 190, 158, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(40),
                      right: Radius.circular(40),
                    ),
                  ),
            duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
          ),
        ),
      );

  Widget _precautionsContainer() => SlideTransition(
        position: slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.chipBackground,
            borderRadius: BorderRadius.circular(40.0),
          ),
          margin: EdgeInsets.only(top: 140, bottom: 100, left: 10, right: 10),
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('유의 사항', style: AppTheme.textTheme.headlineSmall),
              Text(
                '● 핸드폰을 고정시켜서 움직이지 않도록 해주세요.\n\n● AI가 사물을 사람으로 인식할 수 있으니, 주변의 사물들을 정리주세요.\n\n● 배경과 구별되는 색의 옷을 착용해주세요.\n\n● 운동시작 버튼을 누르고 5초 후에 분석이 시작됩니다. 분석이 시작되기 전에 운동을 준비해주세요.\n\n● 카메라에 전체 몸이 보이도록 해주세요.',
                style: AppTheme.textTheme.bodyLarge,
              ),
              ElevatedButton(
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: Colors.white,
                // ),
                onPressed: () {
                  setState(() {
                    if (animationController.status ==
                        AnimationStatus.dismissed) {
                      animationController.forward();
                    } else if (animationController.status ==
                        AnimationStatus.completed) {
                      animationController.reverse();
                    }
                  });
                },
                child: Text('확인'),
              ),
            ],
          ),
        ),
      );
}
