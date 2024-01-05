import 'package:ai_trainer_mypt/providers/exercise_info_provider.dart';
import 'package:ai_trainer_mypt/screens/camera/ai_trainer_page.dart';
import 'package:ai_trainer_mypt/screens/camera/tmp_ui_page.dart';
import 'package:ai_trainer_mypt/screens/mypt_app_home_screen.dart';
import 'package:ai_trainer_mypt/theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import 'screens/camera/ai_trainer_page.dart';
import 'screens/diary/exercise_result_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Permission.camera.request(); // 카메라 권한 요청
  // // 카메라 초기화
  // final cameras = await availableCameras();
  // final firstCamera = cameras.first;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExerciseInfoProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.myAppTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => MyptAppHomeScreen(),
          '/aiTrainer': (context) => TmpUiPage(),
          '/exerciseResult': (context) => ExerciseResultPage(),
        },
      ),
    );
  }
}
