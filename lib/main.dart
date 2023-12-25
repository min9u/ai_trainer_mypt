import 'package:ai_trainer_mypt/screens/mypt_app_home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Pretendard"),
      home: MyptAppHomeScreen(),
    );
  }
}
