import 'dart:convert';

enum exerciseType { squat, pushup, pullup }

class ExerciseDescription {
  final exerciseType type;
  final String description;

  ExerciseDescription({
    required this.type,
    required this.description,
  });

  factory ExerciseDescription.fromJson(Map<String, dynamic> json) {
    return ExerciseDescription(
      type: json['type'],
      description: json['description'],
    );
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
      "description": "AI 스쿼트 자세분석에서는 아래와 같이 좋은 자세를 유지하고 운동을 하고 있는지 분석합니다.\n\n• 완전이완\n• 완전수축\n• 무릎과 골반의 동시수축\n• 무릎의 균형\n• 적절한 운동수행속도\n"
    },
    {
      "type": "pullup",
      "backgroundImage": "assets/images/ai/pullup.jpg",
      "description": "AI 스쿼트 자세분석에서는 아래와 같이 좋은 자세를 유지하고 운동을 하고 있는지 분석합니다.\n\n• 완전이완\n• 완전수축\n• 무릎과 골반의 동시수축\n• 무릎의 균형\n• 적절한 운동수행속도\n"
    },
    {
      "type": "pushup",
      "backgroundImage": "assets/images/ai/pushiup.jpg",
      "description": "AI 스쿼트 자세분석에서는 아래와 같이 좋은 자세를 유지하고 운동을 하고 있는지 분석합니다.\n\n• 완전이완\n• 완전수축\n• 무릎과 골반의 동시수축\n• 무릎의 균형\n• 적절한 운동수행속도\n"
    }
  ]
}
''';

  static ExerciseDescriptionData parseExerciseDescriptionData(String jsonStr) {
    final Map<String, dynamic> parsed = json.decode(jsonStr);
    return ExerciseDescriptionData.fromJson(parsed);
  }
}
