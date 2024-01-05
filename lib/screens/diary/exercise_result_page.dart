import 'package:ai_trainer_mypt/models/exercise_description_data.dart';
import 'package:ai_trainer_mypt/providers/exercise_info_provider.dart';
import 'package:ai_trainer_mypt/screens/diary/component/curve_painter.dart';
import 'package:flutter/material.dart';
import 'package:ai_trainer_mypt/theme.dart';
import 'package:provider/provider.dart';

class ExerciseResultPage extends StatelessWidget {
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
        title: Text(
          '운동 결과',
          style: AppTheme.textTheme.titleMedium,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            // 홈페이지로 이동하고, 기존의 페이지 스택을 모두 제거
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                      height: 240,
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
                                          'assets/images/ai/trainerFeedback.jpg'),
                                      fit: BoxFit.fitWidth)),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            bottom: 60,
                            child: Text(
                              "AI ${exercises[typeIndex].toKorean}\n분석 결과",
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
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.white,
                      child: _resultBody())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultBody() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Text(
                  '자세점수',
                  style: AppTheme.textTheme.labelLarge,
                ),
                SizedBox(
                  height: 8,
                ),
                _curveScoreChart(),
              ],
            ),
            _exerciseMetaDataText(),
          ],
        ),
        _trainerFeedbackGraph(),
        _trainerFeedbackText(),
        SizedBox(
          height: 500,
        )
      ],
    );
  }

  Widget _curveScoreChart() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.all(
                Radius.circular(100.0),
              ),
              border: new Border.all(
                  width: 4, color: AppTheme.grey.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '60',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.normal,
                      fontSize: 24,
                      letterSpacing: 0.0,
                      color: AppTheme.grey),
                ),
                Text(
                  'score',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.0,
                    color: AppTheme.grey.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CustomPaint(
            painter: CurvePainter(
              colors: [
                Color.fromRGBO(77, 190, 158, 1),
                Color.fromRGBO(82, 201, 115, 1),
                // HexColor("#8A98E8"),
                HexColor("#8A98E8")
              ],
              angle: 360 * 0.5,
            ),
            child: SizedBox(
              width: 108,
              height: 108,
            ),
          ),
        ),
      ],
    );
  }

  Widget _exerciseCountView() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        color: Color.fromRGBO(82, 201, 115, 0.6),
        height: 45,
        width: 4,
      ),
      SizedBox(
        width: 12,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '반복 횟수',
            style: AppTheme.textTheme.labelMedium,
          ),
          Row(
              children: [
            Text('🏃'),
            SizedBox(width: 15,),
            SizedBox(
              width: 8,
            ),
            Text(
              '8',
              style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                  letterSpacing: 0.0,
                  color: AppTheme.grey),
            ),
            Text(' 개',style: AppTheme.textTheme.labelSmall,)
          ])
        ],
      )
    ]);
  }

  Widget _kcalView() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        color: Color.fromRGBO(82, 201, 115, 0.6),
        height: 45,
        width: 4,
      ),
      SizedBox(
        width: 12,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '칼로리 소모',
            style: AppTheme.textTheme.labelMedium,
          ),
          Row(
              children: [
            Text('🔥'),
            SizedBox(width: 15,),
            SizedBox(
              width: 8,
            ),
            Text(
              '24',
              style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                  letterSpacing: 0.0,
                  color: AppTheme.grey),
            ),
            Text('  kcal',style: AppTheme.textTheme.labelSmall,)
          ])
        ],
      )
    ]);
  }

  Widget _exerciseMetaDataText() {
    return Container(
      height: 140,
      width: 200,
      decoration: BoxDecoration(
        color: AppTheme.grey.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: EdgeInsets.only(left: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_exerciseCountView(), _kcalView()],
      ),
    );
  }

  Widget _trainerFeedbackGraph() {
    return Container();
  }

  Widget _trainerFeedbackText() {
    return Container();
  }
}
