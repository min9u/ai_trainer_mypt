import 'package:flutter/material.dart';

class ExerciseInfo {
  String type;
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
      type: 'squat', targetCount: 0, showAnimation: true, supportTTS: true);

  ExerciseInfo get exerciseInfo => _exerciseInfo;

  void updateExerciseInfo(ExerciseInfo newInfo) {
    _exerciseInfo = newInfo;
    notifyListeners();
  }
}
