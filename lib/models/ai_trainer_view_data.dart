// ignore_for_file: public_member_api_docs, sort_constructors_first
class AiTrainerViewData {
  String backgroundImagePath;
  String bodyImagePath;
  String title;

  AiTrainerViewData({
    required this.backgroundImagePath,
    required this.bodyImagePath,
    required this.title,
  });

  static List<AiTrainerViewData> aiTrainerViewDataList = [
    AiTrainerViewData(
        backgroundImagePath: 'assets/images/ai/background_1.jpg',
        bodyImagePath: 'assets/images/ai/squat.png',
        title: '스쿼트\n자세 분석'),
    AiTrainerViewData(
        backgroundImagePath: 'assets/images/ai/background_1.jpg',
        bodyImagePath: 'assets/images/ai/squat.png',
        title: '스쿼트\n자세 분석'),
    AiTrainerViewData(
        backgroundImagePath: 'assets/images/ai/background_1.jpg',
        bodyImagePath: 'assets/images/ai/squat.png',
        title: '스쿼트\n자세 분석'),
  ];
}