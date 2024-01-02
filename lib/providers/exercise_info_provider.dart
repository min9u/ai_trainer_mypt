import 'package:ai_trainer_mypt/models/exercise_description_data.dart';
import 'package:flutter/material.dart';

class ExerciseInfo {
  ExerciseType type;
  int targetCount;
  bool showAnimation;
  bool supportTTS;

  ExerciseInfo({
    required this.type,
    required this.targetCount,
    required this.showAnimation,
    required this.supportTTS,
  });
}

class ExerciseInfoProvider extends ChangeNotifier {
  ExerciseInfo _exerciseInfo = ExerciseInfo(
      type: ExerciseType.squat,
      targetCount: 5,
      showAnimation: true,
      supportTTS: true);

  ExerciseInfo get exerciseInfo => _exerciseInfo;

  void updateExerciseInfo(ExerciseInfo newInfo) {
    _exerciseInfo = newInfo;
    notifyListeners();
  }
}
