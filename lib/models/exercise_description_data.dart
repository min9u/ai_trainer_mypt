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
      "description": "스쿼트는 하체 근육을 강화하는데 효과적인 운동입니다."
    },
    {
      "type": "pullup",
      "description": "풀업은 상체 근육을 강화하는데 효과적인 운동입니다."
    },
    {
      "type": "pushup",
      "description": "푸쉬업은 가슴과 삼두 근육을 강화하는데 효과적인 운동입니다."
    }
  ]
}
''';

  static ExerciseDescriptionData parseExerciseDescriptionData(String jsonStr) {
    final Map<String, dynamic> parsed = json.decode(jsonStr);
    return ExerciseDescriptionData.fromJson(parsed);
  }
}
