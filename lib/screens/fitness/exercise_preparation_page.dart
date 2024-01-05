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
    // json 에서 type에 해당하는 데이터와 index를 뽑는 과정
    var provider = Provider.of<ExerciseInfoProvider>(context);
    ExerciseType type = provider.exerciseInfo.type;
    ExerciseDescriptionData data =
        ExerciseDescriptionData.parseExerciseDescriptionData(
            ExerciseDescriptionData.descriptionJson);
    List<ExerciseDescription> exercises = data.exercises;
    int typeIndex = 0;
    for (int i = 0; i < exercises.length; i++) {
      if (exercises[i].type == type) {
        typeIndex = i;
        break;
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '운동 준비',
            style: AppTheme.textTheme.titleMedium,
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
                                        image: AssetImage(exercises[typeIndex]
                                            .backgroundImage),
                                        fit: BoxFit.fitWidth)),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              bottom: 60,
                              child: Text(
                                exercises[typeIndex].title,
                                style: AppTheme.whiteHeadline,
                              ),
                            ),
                            Positioned(
                              bottom: -2,
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
                      color: Colors.white,
                      child: Column(
                        children: [
                          _buildExerciseDescription(
                              context, exercises[typeIndex].description),
                          SizedBox(
                            height: 15,
                          ),
                          _buildCountText(context),
                          _buildSlideCount(context),
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/aiTrainer');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '운동 준비',
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
          style: AppTheme.textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildExerciseDescription(BuildContext context, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppTheme.textTheme.bodyLarge,
        ),
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
