import 'package:ai_trainer_mypt/ai_models/pull_up_analysis.dart';
import 'package:ai_trainer_mypt/ai_models/push_up_analysis.dart';
import 'package:ai_trainer_mypt/ai_models/squat_analysis.dart';
import 'package:ai_trainer_mypt/ai_models/workout_analysis.dart';
import 'package:ai_trainer_mypt/screens/camera/camera_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ai_trainer_mypt/utils/pose_painter.dart';

class AiTrainerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AiTrainerPageState();
}

class _AiTrainerPageState extends State<AiTrainerPage> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  // ai trainer
  PoseDetector poseDetector = GoogleMlKit.vision.poseDetector(
      poseDetectorOptions:
          PoseDetectorOptions(model: PoseDetectionModel.accurate));
  // PoseDetector poseDetector = GoogleMlKit.vision.poseDetector();
  bool isBusy = false;
  CustomPaint? customPaint;
  late WorkoutAnalysis workoutAnalysis;

  @override
  void initState() {
    // initiate workoutAnalysis abstract class object
    super.initState();

    if (widget.workoutName == 'Push Up') {
      workoutAnalysis = PushUpAnalysis(targetCount: widget.targetCount);
    } else if (widget.workoutName == 'Squat') {
      workoutAnalysis = SquatAnalysis(targetCount: widget.targetCount);
    } else if (widget.workoutName == 'Pull Up') {
      workoutAnalysis = PullUpAnalysis(targetCount: widget.targetCount);
    } else {
      workoutAnalysis = PullUpAnalysis(targetCount: widget.targetCount);
    }
  }

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Pose Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}

enum DetectorViewMode { liveFeed, gallery }

class DetectorView extends StatefulWidget {
  DetectorView({
    Key? key,
    required this.title,
    required this.onImage,
    this.customPaint,
    this.text,
    this.initialDetectionMode = DetectorViewMode.liveFeed,
    this.initialCameraLensDirection = CameraLensDirection.back,
    this.onCameraFeedReady,
    this.onDetectorViewModeChanged,
    this.onCameraLensDirectionChanged,
  }) : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final DetectorViewMode initialDetectionMode;
  final Function(InputImage inputImage) onImage;
  final Function()? onCameraFeedReady;
  final Function(DetectorViewMode mode)? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;

  @override
  State<DetectorView> createState() => _DetectorViewState();
}

class _DetectorViewState extends State<DetectorView> {
  late DetectorViewMode _mode;

  @override
  void initState() {
    _mode = widget.initialDetectionMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      customPaint: widget.customPaint,
      onImage: widget.onImage,
      onCameraFeedReady: widget.onCameraFeedReady,
      onDetectorViewModeChanged: _onDetectorViewModeChanged,
      initialCameraLensDirection: widget.initialCameraLensDirection,
      onCameraLensDirectionChanged: widget.onCameraLensDirectionChanged,
    );
  }

  void _onDetectorViewModeChanged() {
    if (_mode == DetectorViewMode.liveFeed) {
      _mode = DetectorViewMode.gallery;
    } else {
      _mode = DetectorViewMode.liveFeed;
    }
    if (widget.onDetectorViewModeChanged != null) {
      widget.onDetectorViewModeChanged!(_mode);
    }
    setState(() {});
  }
}
