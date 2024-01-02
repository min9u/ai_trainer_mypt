import 'dart:convert';

enum ExerciseType { squat, pushup, pullup }

class ExerciseDescription {
  final ExerciseType type;
  final String description;
  final String backgroundImage;
  final String title;

  ExerciseDescription(
      {required this.type,
      required this.description,
      required this.backgroundImage,
      required this.title});

  factory ExerciseDescription.fromJson(Map<String, dynamic> json) {
    ExerciseType exerciseType;
    switch (json['type']) {
      case 'squat':
        exerciseType = ExerciseType.squat;
      case 'pullup':
        exerciseType = ExerciseType.pullup;
      case 'pushup':
        exerciseType = ExerciseType.pushup;
      default:
        exerciseType = ExerciseType.squat;
    }

    return ExerciseDescription(
        type: exerciseType,
        description: json['description'],
        backgroundImage: json['backgroundImage'],
        title: json['title']);
  }
}

class ExerciseDescriptionData {
  List<ExerciseDescription> exercises;

  ExerciseDescriptionData({required this.exercises});

  factory ExerciseDescriptionData.fromJson(Map<String, dynamic> json) {
    List<dynamic> exercisesList = json['exercises'];
    List<ExerciseDescription> exercises = exercisesList.map((exercise) {
      return ExerciseDescription.fromJson(exercise);
    }).toList();

    return ExerciseDescriptionData(exercises: exercises);
  }

  static String descriptionJson = '''
{
  "exercises": [
    {
      "type": "squat",
      "backgroundImage": "assets/images/ai/squat.jpg",
      "description": "AI 스쿼트 자세분석에서는 아래와 같이 좋은 자세를 유지하고 운동을 하고 있는지 분석합니다.\\n\\n• 완전이완\\n• 완전수축\\n• 무릎과 골반의 동시수축\\n• 무릎의 균형\\n• 적절한 운동수행속도\\n\\n자세에 신경쓰면서 완벽한 스쿼트에 도전해보세요! 🔥",
      "title": "AI 스쿼트\\n운동자세분석"
    },
    {
      "type": "pullup",
      "backgroundImage": "assets/images/ai/pullup.jpg",
      "description": "AI 스쿼트 자세분석에서는 아래와 같이 좋은 자세를 유지하고 운동을 하고 있는지 분석합니다.\\n\\n• 완전이완\\n• 완전수축\\n• 무릎과 골반의 동시수축\\n• 무릎의 균형\\n• 적절한 운동수행속도\\n\\n자세에 신경쓰면서 완벽한 스쿼트에 도전해보세요! 🔥",
      "title": "AI 풀업\\n운동자세분석"
    },
    {
      "type": "pushup",
      "backgroundImage": "assets/images/ai/pushup.jpg",
      "description": "AI 스쿼트 자세분석에서는 아래와 같이 좋은 자세를 유지하고 운동을 하고 있는지 분석합니다.\\n\\n• 완전이완\\n• 완전수축\\n• 무릎과 골반의 동시수축\\n• 무릎의 균형\\n• 적절한 운동수행속도\\n\\n자세에 신경쓰면서 완벽한 스쿼트에 도전해보세요! 🔥",
      "title": "AI 푸쉬업\\n운동자세분석"
    }
  ]
}
''';

  static ExerciseDescriptionData parseExerciseDescriptionData(String jsonStr) {
    final Map<String, dynamic> parsed = json.decode(jsonStr);
    return ExerciseDescriptionData.fromJson(parsed);
  }
}
