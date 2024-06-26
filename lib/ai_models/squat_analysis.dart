// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../utils/function_utils.dart';
import 'dart:convert';

import 'package:ai_trainer_mypt/utils/tts_voice.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'workout_analysis.dart';
import 'workout_result.dart';
import 'package:ai_trainer_mypt/utils/function_utils.dart';
// import 'package:firebase_auth/firebase_auth.dart';

const Map<String, List<int>> jointIndx = {
  'right_hip': [12, 24, 26],
  'right_knee': [24, 26, 28]
};

class SquatAnalysis implements WorkoutAnalysis {
  final Voice speaker = Voice();
  String _state = 'up'; // up, down, none

  Map<String, List<double>> _tempAngleDict = {
    'right_hip': <double>[],
    'right_knee': <double>[],
    'avg_hip_knee': <double>[],
    'foot_length': <double>[],
    'toe_location': <double>[]
  };

  Map<String, List<int>> _feedBack = {
    'not_relaxation': <int>[],
    'not_contraction': <int>[],
    'hip_dominant': <int>[],
    'knee_dominant': <int>[],
    'not_knee_in': <int>[],
    'is_speed_fast': <int>[]
  };

  int _count = 0;
  bool _detecting = false;
  int targetCount;
  bool _end = false;

  get feedBack => _feedBack;
  get tempAngleDict => _tempAngleDict;
  get count => _count;
  get detecting => _detecting;
  get end => _end;
  get state => _state;

  SquatAnalysis({required this.targetCount});

  late int start;
  final List<String> _keys = jointIndx.keys.toList();
  final List<List<int>> _vals = jointIndx.values.toList();

  bool isStart = false;
  bool isKneeOut = false;
  late double footLength;
  late double kneeX;
  late double toeX;

  void detect(Pose pose) {
    // 포즈 추정한 관절값을 바탕으로 개수를 세고, 자세를 평가
    Map<PoseLandmarkType, PoseLandmark> landmarks = pose.landmarks;
    for (int i = 0; i < jointIndx.length; i++) {
      List<List<double>> listXyz = findXyz(_vals[i], landmarks);
      double angle = calculateAngle3D(listXyz, direction: 1);
      _tempAngleDict[_keys[i]]!.add(angle);
    }
    kneeX = landmarks[PoseLandmarkType.values[26]]!.x;
    toeX = landmarks[PoseLandmarkType.values[32]]!.x;

    if (_state == 'up') {
      if (isStart == true) {
        footLength = getDistance(landmarks[PoseLandmarkType.values[32]]!,
            landmarks[PoseLandmarkType.values[30]]!);
        _tempAngleDict['foot_length']!.add(footLength);
        _tempAngleDict['toe_location']!.add(toeX);
      }
    } else if (_tempAngleDict['foot_length']!.isNotEmpty &&
        _tempAngleDict['toe_location']!.isNotEmpty) {
      if (customSum(_tempAngleDict['foot_length']!) /
                  _tempAngleDict['foot_length']!.length *
                  0.15 +
              customSum(_tempAngleDict['toe_location']!) /
                  _tempAngleDict['toe_location']!.length <
          kneeX) {
        isKneeOut = true;
      }
    }
    double hipAngle = _tempAngleDict['right_hip']!.last;
    double kneeAngle = _tempAngleDict['right_knee']!.last;
    if (hipAngle > 215 && hipAngle < 350) {
      _tempAngleDict['avg_hip_knee']!.add((hipAngle + kneeAngle) / 2);
    }
    if (!isStart &&
        _detecting &&
        hipAngle > 160 &&
        hipAngle < 205 &&
        kneeAngle > 160 &&
        kneeAngle < 205) {
      speaker.sayStart();
      isStart = true;
    }

    if (!isStart) {
      int indx = _tempAngleDict['right_hip']!.length - 1;
      _tempAngleDict['right_hip']!.removeAt(indx);
      _tempAngleDict['right_knee']!.removeAt(indx);
      if (hipAngle > 215 && hipAngle < 350) {
        int indx2 = _tempAngleDict['avg_hip_knee']!.length - 1;
        _tempAngleDict['avg_hip_knee']!.removeAt(indx2);
      }
    } else {
      if (isOutlierSquats(_tempAngleDict['right_hip']!, 0) ||
          isOutlierSquats(_tempAngleDict['right_knee']!, 1)) {
        int indx = _tempAngleDict['right_hip']!.length - 1;
        _tempAngleDict['right_hip']!.removeAt(indx);
        _tempAngleDict['right_knee']!.removeAt(indx);
        if (hipAngle > 215 && hipAngle < 350) {
          int indx2 = _tempAngleDict['avg_hip_knee']!.length - 1;
          _tempAngleDict['avg_hip_knee']!.removeAt(indx2);
        }
      } else {
        bool isHipUp = hipAngle < 215;
        bool isHipDown = hipAngle > 240;
        bool isKneeUp = kneeAngle > 147.5;

        if (isHipUp && isKneeUp && _state == 'down') {
          //개수 카운팅
          ++_count;
          speaker.countingVoice(_count);
          //speaker.stopState();
          int end = DateTime.now().second;
          _state = 'up';

          if (listMin(_tempAngleDict['right_hip']!) < 205) {
            //엉덩이를 완전히 이완
            _feedBack['not_relaxation']!.add(0);
          } else {
            //엉덩이 덜 이완
            _feedBack['not_relaxation']!.add(1);
          }
          if (listMax(_tempAngleDict['right_hip']!) > 270) {
            //엉덩이가 완전히 내려간 경우
            _feedBack['not_contraction']!.add(0);
          } else {
            //엉덩이가 덜 내려간 경우
            _feedBack['not_contraction']!.add(1);
          }
          if (listMax(_tempAngleDict['avg_hip_knee']!) > 205) {
            //엉덩이가 먼저 내려간 경우
            _feedBack['hip_dominant']!.add(1);
            _feedBack['knee_dominant']!.add(0);
          } else if (listMin(_tempAngleDict['avg_hip_knee']!) < 173) {
            //무릎이 먼저 내려간 경우
            _feedBack['hip_dominant']!.add(0);
            _feedBack['knee_dominant']!.add(1);
          } else {
            //무릎과 엉덩이가 균형있게 내려간 경우
            _feedBack['hip_dominant']!.add(0);
            _feedBack['knee_dominant']!.add(0);
            ;
          }
          if (isKneeOut) {
            //무릎이 발 밖으로 나간 경우
            _feedBack['not_knee_in']!.add(1);
          } else {
            //무릎이 발 안쪽에 있는 경우
            _feedBack['not_knee_in']!.add(0);
          }
          if ((end - start) < 1.5) {
            _feedBack['is_speed_fast']!.add(1);
          } else {
            _feedBack['is_speed_fast']!.add(0);
          }

          if (_feedBack['not_knee_in']!.last == 1) {
            //무릎이 발 밖으로 나간 경우
            speaker.sayKneeOut(_count);
          } else {
            //무릎이 발 안쪽에 있는 경우
            if (_feedBack['hip_dominant']!.last == 1 ||
                _feedBack['knee_dominant']!.last == 1) {
              // 엉덩이가 먼저 내려가거나 무릎이 먼저 내려간 경우
              speaker.sayHipKnee(_count);
            } else {
              //무릎과 엉덩이가 균형있게 내려간 경우
              if (_feedBack['not_relaxation']!.last == 0) {
                //엉덩이를 완전히 이완
                if (_feedBack['not_contraction']!.last == 0) {
                  //엉덩이가 완전히 내려간 경우
                  if (_feedBack['is_speed_fast']!.last == 0) {
                    //속도가 적당한 경우
                    speaker.sayGood1(_count);
                  } else {
                    //속도가 빠른 경우
                    speaker.sayFast(_count);
                  }
                } else {
                  //엉덩이가 덜 내려간 경우
                  speaker.sayHipDown(_count);
                }
              } else {
                //엉덩이 덜 이완
                speaker.sayStretchKnee(_count);
              }
            }
          }

          //초기화
          _tempAngleDict['right_hip'] = <double>[];
          _tempAngleDict['right_knee'] = <double>[];
          _tempAngleDict['avg_hip_knee'] = <double>[];
          _tempAngleDict['foot_length'] = <double>[];
          _tempAngleDict['toe_location'] = <double>[];

          isKneeOut = false;

          if (_count == targetCount) {
            stopAnalysingDelayed();
          }
        } else if (isHipDown && !isKneeUp && _state == 'up') {
          _state = 'down';
          start = DateTime.now().second;
        }
      }
    }
  }

  List<int> workoutToScore() {
    List<int> score = [];
    int n = _count;
    for (int i = 0; i < n; i++) {
      //_e는 pushups에 담겨있는 각각의 element
      int isRelaxation = 1 - _feedBack['not_relaxation']![i];
      int isContraction = 1 - _feedBack['not_contraction']![i];
      int isHipKneeGood = (_feedBack['hip_dominant']![i] == 0 &&
              _feedBack['knee_dominant']![i] == 0)
          ? 1
          : 0;
      int isKneeIn = 1 - _feedBack['not_knee_in']![i];
      int isSpeedgood = 1 - _feedBack['is_speed_fast']![i];
      score.add(isRelaxation * 10 +
          isContraction * 20 +
          isHipKneeGood * 50 +
          isKneeIn * 13 +
          isSpeedgood * 7);
    }
    return score;
  }

  @override
  void startDetecting() {
    _detecting = true;
  }

  @override
  Future<void> startDetectingDelayed() async {
    speaker.sayStartDelayed();
    await Future.delayed(const Duration(seconds: 8), () {
      startDetecting();
    });
  }

  void stopDetecting() {
    _detecting = false;
  }

  void stopAnalysing() {
    _end = true;
  }

  Future<void> stopAnalysingDelayed() async {
    stopAnalysing();
    await Future.delayed(const Duration(seconds: 1), () {
      speaker.sayEnd();
    });
  }

  // WorkoutResult makeWorkoutResult() {
  //   CollectionReference user_file =
  //       FirebaseFirestore.instance.collection('user_file');
  //   var currentUser = FirebaseAuth.instance.currentUser;
  //   String userUid = currentUser!.uid;

  //   List<int> feedbackCounts = <int>[]; // sum of feedback which value is 1
  //   for (String key in _feedBack.keys.toList()) {
  //     int tmp = 0;
  //     for (int i = 0; i < _count; i++) {
  //       tmp += _feedBack[key]![i];
  //     }
  //     feedbackCounts.add(tmp);
  //   }
  //   WorkoutResult workoutResult = WorkoutResult(
  //       user: '10', // firebase로 구현
  //       uid: userUid, // firebase로 구현
  //       workoutName: 'squat',
  //       count: _count,
  //       score: workoutToScore(),
  //       feedbackCounts: feedbackCounts);
  //   print(jsonEncode(workoutResult));
  //   return workoutResult;
  // }

  // void saveWorkoutResult() async {
  //   WorkoutResult workoutResult = makeWorkoutResult();
  //   String json = jsonEncode(workoutResult);
  //   print(json);

  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  //   CollectionReference exerciseDB =
  //       FirebaseFirestore.instance.collection('exercise_DB');

  //   Future<void> exercisestart() {
  //     // Call the user's CollectionReference to add a new user
  //     print("streamstart");
  //     return exerciseDB
  //         .doc()
  //         .set(workoutResult.toJson())
  //         .then((value) => print("json added"))
  //         .catchError((error) => print("Failed to add json: $error"));
  //   }

  //   exercisestart();
  //   WidgetsFlutterBinding.ensureInitialized();
  //   Firebase.initializeApp();

  //   var currentUser = FirebaseAuth.instance.currentUser;
  //   String uid_name = currentUser!.uid;
  //   int new_squat = workoutResult.toJson()['squat'];
  //   print(uid_name);

  //   CollectionReference leaderboard =
  //       FirebaseFirestore.instance.collection('leaderboard_DB');

  //   var docSnapshot = await leaderboard.doc(uid_name).get();
  //   Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
  //   int old_squat = data!['squat'];
  //   int old_score = data['score'];

  //   if (new_squat > old_squat) {
  //     int new_score = new_squat - old_squat + old_score;
  //     leaderboard
  //         .doc(uid_name)
  //         .update({'squat': new_squat, 'score': new_score});
  //   }
  //   print("streamend");
  // }
}
