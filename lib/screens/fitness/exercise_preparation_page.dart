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
    return Scaffold(
        appBar: AppBar(
          title: Text('운동 준비 페이지'),
        ),
        body: Container(
          child: SingleChildScrollView(
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
                                        'assets/images/ai/squat.jpg'),
                                    fit: BoxFit.fitWidth)),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          bottom: 60,
                          child: Text(
                            'AI 스쿼트\n운동자세분석',
                            style: AppTheme.textTheme.headlineSmall,
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
                      _buildTextField(context),
                      _buildSwitch(context, '실시간 카메라 애니메이션'),
                      _buildSwitch(context, '실시간음성피드백'),
                      _buildStartButton(context)
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildTextField(BuildContext context) {
    var provider = Provider.of<ExerciseInfoProvider>(context);
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (String value) {
        provider.updateExerciseInfo(
          ExerciseInfo(
            type: provider.exerciseInfo.type,
            targetCount: int.parse(value),
            showAnimation: provider.exerciseInfo.showAnimation,
            supportTTS: provider.exerciseInfo.supportTTS,
          ),
        );
      },
      decoration: InputDecoration(labelText: '운동 개수'),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 여기에서 운동분석 페이지로 이동하거나 다른 작업을 수행할 수 있습니다.
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ExerciseAnalysisPage()),
        // );
      },
      child: Text('운동 시작'),
    );
  }

  Widget _buildExerciseDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI 스쿼트 자세분석에서는 아래와 같이 좋은 자세를 유지하고 운동을 하고 있는지 분석합니다.',
          style: AppTheme.textTheme.bodyLarge,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '• 완전이완\n• 완전수축\n• 무릎과 골반의 동시수축\n• 무릎의 균형\n• 적절한 운동수행속도',
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

  Widget _buildSwitch(BuildContext context, String title) {
    var provider = Provider.of<ExerciseInfoProvider>(context);
    return SwitchListTile(
      title: Text(title),
      value: title == '실시간 카메라 애니메이션'
          ? provider.exerciseInfo.showAnimation
          : provider.exerciseInfo.supportTTS,
      onChanged: (bool value) {
        provider.updateExerciseInfo(
          ExerciseInfo(
            type: provider.exerciseInfo.type,
            targetCount: provider.exerciseInfo.targetCount,
            showAnimation: title == '실시간 카메라 애니메이션'
                ? value
                : provider.exerciseInfo.showAnimation,
            supportTTS:
                title == '실시간 음성피드백' ? value : provider.exerciseInfo.supportTTS,
          ),
        );
      },
    );
  }

  Widget _buildExerciseInfo(BuildContext context) {
    ExerciseInfoProvider provider = Provider.of<ExerciseInfoProvider>(context);
    ExerciseDescription exerciseDescription =
        _getExerciseDescription(provider.exerciseInfo.type);

    return Column(
      children: [
        Text('운동 종류: ${provider.exerciseInfo.type}'),
        Text('운동 개수: ${provider.exerciseInfo.targetCount}'),
        Text('애니메이션: ${provider.exerciseInfo.showAnimation ? '활성화' : '비활성화'}'),
        Text(
            '실시간 TTS 피드백: ${provider.exerciseInfo.supportTTS ? '활성화' : '비활성화'}'),
        SizedBox(height: 16.0),
        Text('운동 설명: ${exerciseDescription.description}'),
      ],
    );
  }

  ExerciseDescription _getExerciseDescription(String exerciseType) {
    // ai_trainer_description_data.dart 파일에서 데이터 가져오기
    ExerciseDescriptionData data =
        ExerciseDescriptionData.parseExerciseDescriptionData(
            ExerciseDescriptionData.descriptionJson);
    return data.exercises
        .firstWhere((exercise) => exercise.type == exerciseType);
  }
}
