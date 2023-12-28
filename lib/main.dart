import 'package:ai_trainer_mypt/providers/exercise_info_provider.dart';
import 'package:ai_trainer_mypt/screens/mypt_app_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExerciseInfoProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Pretendard"),
        home: MyptAppHomeScreen(),
      ),
    );
  }
}
