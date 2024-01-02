import 'package:flutter/material.dart';

class ExerciseResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동결과'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            // 홈페이지로 이동하고, 기존의 페이지 스택을 모두 제거
          },
        ),
      ),
      body: Center(
        child: Text('운동 결과 페이지'),
      ),
    );
  }
}
