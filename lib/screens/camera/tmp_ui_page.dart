import 'dart:io';

import 'package:ai_trainer_mypt/theme.dart';
import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ai_trainer_mypt/theme.dart';
import 'package:ai_trainer_mypt/models/app_icon_data.dart';

class TmpUiPage extends StatefulWidget {
  const TmpUiPage({super.key});

  @override
  State<TmpUiPage> createState() => _TmpUiPageState();
}

class _TmpUiPageState extends State<TmpUiPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  bool isExerciseStarted = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        // fit: StackFit.expand,
        children: [
          Center(child: const Text('hello')),
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
    ));
  }

  Widget _settingIconToggle() => Positioned(
        top: 20,
        right: 10,
        child: IconButton(
          onPressed: (){},
          icon: Icon(
            Icons.settings,
            size: 30,
          ),
        ),
      );

  Widget _switchLiveCameraToggle() => Positioned(
      top: 20,
      left: 10,
      child: IconButton(
        onPressed: (){},
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
                '운동수행속도 : O',
                style: AppTheme.textTheme.bodyMedium,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(120, 120, 120, 0.2),
              borderRadius: BorderRadius.all(Radius.circular(30))),
        ),
      );

  Widget _startStopButton() => Positioned(
        bottom: 20,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if(!isExerciseStarted){
                isExerciseStarted = !isExerciseStarted;
              } else {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    backgroundColor: AppTheme.chipBackground,
                    title: const Text('운동을 중지하시겠습니까?', style: AppTheme.titleMedium,),
                    content: const Text('운동을 중지하면 운동을 이어서 할 수 없습니다.'),
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
                    color: Color.fromRGBO(83, 189, 113, 1),
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
