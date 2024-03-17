import 'package:ai_trainer_mypt/models/exercise_description_data.dart';
import 'package:ai_trainer_mypt/providers/exercise_info_provider.dart';
import 'package:ai_trainer_mypt/screens/diary/component/curve_painter.dart';
import 'package:ai_trainer_mypt/screens/diary/component/line_painter.dart';
import 'package:flutter/material.dart';
import 'package:ai_trainer_mypt/theme.dart';
import 'package:provider/provider.dart';

//TODO line painter의 길이 어떻게 정의할지 고민

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
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      color: Colors.white,
                      child: _resultBody(context))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        SizedBox(
          height: 20,
        ),
        _trainerFeedbackGraph(context),
        SizedBox(
          height: 20,
        ),
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
          Row(children: [
            Text('🏃'),
            SizedBox(
              width: 15,
            ),
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
            Text(
              ' 개',
              style: AppTheme.textTheme.labelSmall,
            )
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
          Row(children: [
            Text('🔥'),
            SizedBox(
              width: 15,
            ),
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
            Text(
              '  kcal',
              style: AppTheme.textTheme.labelSmall,
            )
          ])
        ],
      )
    ]);
  }

  Widget _exerciseMetaDataText() {
    return Container(
      height: 140,
      width: 170,
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

  Widget _trainerFeedbackGraph(BuildContext context) {
    return Container(
      height: 160,
      width: 2000,
      decoration: BoxDecoration(
        color: AppTheme.grey.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _feedbackLine(context, '운동 속도', 0.8),
          _feedbackLine(context, '완전 수축', 0.9),
          _feedbackLine(context, '완전 이완', 0.9),
          _feedbackLine(context, '무릎 안정', 0.4),
          _feedbackLine(context, '골반 안정', 0.7),
        ],
      ),
    );
  }

  Widget _feedbackLine(
      BuildContext context, String feedbackName, double opacity) {
    // TODO opacity 별로 색깔을 다르게 하도록 개발
    return Row(
      children: [
        Text(
          feedbackName,
          style: AppTheme.textTheme.labelMedium,
        ),
        SizedBox(
          width: 30,
        ),
        CustomPaint(
          painter: LinePainter(colors: [
            Color.fromRGBO(77, 190, 158, 1),
            Color.fromRGBO(82, 201, 115, 1),
          ], length: MediaQuery.of(context).size.width * 0.5, opacity: opacity),
        ),
      ],
    );
  }

  Widget _trainerFeedbackText() {
    return Container(
        height: 160,
        width: 2000,
        decoration: BoxDecoration(
          color: AppTheme.grey.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: EdgeInsets.all(16.0),
        child: Text(
            '적절한 속도로 운동하고 있어요. 운동시 완전수축, 완전운동을 통해 큰 가동범위를 사용하고 있어요.\n\n하지만 무릎과 골반이 동시에 수축하지 않고 따로 수축하고 있어요. 동시에 관절들을 움직이지 않으면 무릎과 골반의 부상을 야기할 수 있어요.'));
  }
}
