// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ai_trainer_mypt/models/exercise_description_data.dart';

class AiTrainerViewData {
  exerciseType type;
  String backgroundImagePath;
  String bodyImagePath;
  String title;

  AiTrainerViewData({
    required this.type,
    required this.backgroundImagePath,
    required this.bodyImagePath,
    required this.title,
  });

  static List<AiTrainerViewData> aiTrainerViewDataList = [
    AiTrainerViewData(
        type: exerciseType.squat,
        backgroundImagePath: 'assets/images/ai/background_1.jpg',
        bodyImagePath: 'assets/images/ai/squat.png',
        title: 'AI 스쿼트\n트레이너'),
    AiTrainerViewData(
        type: exerciseType.pushup,
        backgroundImagePath: 'assets/images/ai/background_1.jpg',
        bodyImagePath: 'assets/images/ai/pushup.png',
        title: 'AI 푸쉬업\n트레이너'),
    AiTrainerViewData(
        type: exerciseType.pullup,
        backgroundImagePath: 'assets/images/ai/background_1.jpg',
        bodyImagePath: 'assets/images/ai/pullup.png',
        title: 'AI 풀업\n트레이너'),
  ];
}
