import 'package:ai_trainer_mypt/models/exercise_description_data.dart';
import 'package:ai_trainer_mypt/providers/exercise_info_provider.dart';
import 'package:ai_trainer_mypt/theme.dart';
import 'package:ai_trainer_mypt/widgets/text_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExercisePreparationPage extends StatelessWidget {
  const ExercisePreparationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ExerciseInfoProvider>(context);
    exerciseType type = provider.exerciseInfo.type;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '운동 준비',
            style: AppTheme.textTheme.titleLarge,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(title: const Text('설정')),
                      body: Column(children: [
                        _buildAnimationSwitch(context),
                        _buildTtsSwitch(context)
                      ]),
                    );
                  }));
                },
                icon: Icon(Icons.settings))
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                        height: 260,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 260,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/ai/pullup.jpg'),
                                        fit: BoxFit.fitWidth)),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              bottom: 60,
                              child: Text(
                                'AI 스쿼트\n운동자세분석',
                                style: AppTheme.whiteHeadline,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40)),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildExerciseDescription(context),
                          SizedBox(
                            height: 15,
                          ),
                          _buildSlideCount(context),
                          _buildCountText(context),
                          SizedBox(
                            height: 200,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '운동 시작',
                    style: AppTheme.whiteTitle,
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(82, 201, 115, 1),
                        Color.fromRGBO(77, 190, 158, 1)
                      ]),
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(40),
                          right: Radius.circular(40))),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildSlideCount(BuildContext context) {
    var provider = Provider.of<ExerciseInfoProvider>(context);

    return Slider(
        activeColor: Color.fromRGBO(80, 195, 134, 1),
        value: provider.exerciseInfo.targetCount.toDouble(),
        max: 30,
        divisions: 6,
        onChanged: (double value) {
          provider.updateExerciseInfo(ExerciseInfo(
              type: provider.exerciseInfo.type,
              targetCount: value != 0
                  ? value.toInt()
                  : provider.exerciseInfo.targetCount,
              showAnimation: provider.exerciseInfo.showAnimation,
              supportTTS: provider.exerciseInfo.supportTTS));
        });
  }

  Widget _buildCountText(BuildContext context) {
    var provider = Provider.of<ExerciseInfoProvider>(context);

    String emojiMaker(int count) {
      switch (count) {
        case 5:
          return '🌱';
        case 10:
          return '☘️';
        case 15:
          return '🍀';
        case 20:
          return '🌿';
        case 25:
          return '🪴';
        case 30:
          return '🌳';
        default:
          return '🌱';
      }
    }

    return Column(
      children: [
        Text(emojiMaker(provider.exerciseInfo.targetCount),
            style: AppTheme.textTheme.headlineSmall),
        SizedBox(height: 5),
        Text(
          '반복횟수 : ${provider.exerciseInfo.targetCount}',
          style: AppTheme.textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildExerciseDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI 스쿼트 자세분석에서는 아래와 같이 좋은 자세를 유지하고 운동을 하고 있는지 분석합니다.\n\n• 완전이완\n• 완전수축\n• 무릎과 골반의 동시수축\n• 무릎의 균형\n• 적절한 운동수행속도',
          style: AppTheme.textTheme.bodyLarge,
        ),
        SizedBox(
          height: 10,
        ),
        Text('자세에 신경쓰면서 완벽한 스쿼트에 도전해보세요! 🔥',
            style: AppTheme.textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildAnimationSwitch(BuildContext context) {
    var provider = Provider.of<ExerciseInfoProvider>(context);
    return SwitchListTile(
      title: Text('자세 추정 애니메이션'),
      value: provider.exerciseInfo.showAnimation,
      onChanged: (bool value) {
        provider.updateExerciseInfo(ExerciseInfo(
            type: provider.exerciseInfo.type,
            targetCount: provider.exerciseInfo.targetCount,
            showAnimation: value,
            supportTTS: provider.exerciseInfo.supportTTS));
      },
    );
  }

  Widget _buildTtsSwitch(BuildContext context) {
    var provider = Provider.of<ExerciseInfoProvider>(context);
    return SwitchListTile(
      title: Text('실시간 tts 음성 피드백'),
      value: provider.exerciseInfo.showAnimation,
      onChanged: (bool value) {
        provider.updateExerciseInfo(ExerciseInfo(
            type: provider.exerciseInfo.type,
            targetCount: provider.exerciseInfo.targetCount,
            showAnimation: provider.exerciseInfo.showAnimation,
            supportTTS: value));
      },
    );
  }
}
