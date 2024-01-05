// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ai_trainer_mypt/models/exercise_description_data.dart';

class AiTrainerViewData {
  ExerciseType type;
  String backgroundImagePath;
  String bodyImagePath;
  String prepararationTitle;

  AiTrainerViewData({
    required this.type,
    required this.backgroundImagePath,
    required this.bodyImagePath,
    required this.prepararationTitle,
  });

  static List<AiTrainerViewData> aiTrainerViewDataList = [
    AiTrainerViewData(
        type: ExerciseType.squat,
        backgroundImagePath: 'assets/images/ai/background_1.jpg',
        bodyImagePath: 'assets/images/ai/squat.png',
        prepararationTitle: 'AI 스쿼트\n트레이너'),
    AiTrainerViewData(
        type: ExerciseType.pushup,
        backgroundImagePath: 'assets/images/ai/background_1.jpg',
        bodyImagePath: 'assets/images/ai/pushup.png',
        prepararationTitle: 'AI 푸쉬업\n트레이너'),
    AiTrainerViewData(
        type: ExerciseType.pullup,
        backgroundImagePath: 'assets/images/ai/background_1.jpg',
        bodyImagePath: 'assets/images/ai/pullup.png',
        prepararationTitle: 'AI 풀업\n트레이너'),
  ];
}
