import 'package:ai_trainer_mypt/providers/exercise_info_provider.dart';
import 'package:ai_trainer_mypt/screens/mypt_app_home_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import 'screens/camera/camera_page.dart';
import 'screens/record/exercise_result_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request(); // 카메라 권한 요청

  // 카메라 초기화
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExerciseInfoProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Pretendard"),
        initialRoute: '/',
        routes: {
          '/': (context) => MyptAppHomeScreen(),
          '/camera': (context) => CameraPage(camera: camera),
          '/exerciseResult': (context) => ExerciseResultPage(),
        },
      ),
    );
  }
}
