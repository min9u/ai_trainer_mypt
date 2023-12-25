import 'package:ai_trainer_mypt/screens/fitness/component/ai_trainer_view.dart';
import 'package:ai_trainer_mypt/screens/fitness/component/category_view.dart';
import 'package:ai_trainer_mypt/screens/fitness/component/track_view.dart';
import 'package:ai_trainer_mypt/theme.dart';
import 'package:ai_trainer_mypt/widgets/text_view.dart';
import 'package:flutter/material.dart';

class FitnessHomeScreen extends StatefulWidget {
  const FitnessHomeScreen({super.key});

  @override
  State<FitnessHomeScreen> createState() => _FitnessHomeScreenState();
}

class _FitnessHomeScreenState extends State<FitnessHomeScreen> {
  List<Widget> listViews = <Widget>[];

  // listViews 안에 모든 뷰를 담는 함수
  void addAllListData() {
    listViews.add(TextView(
      title: '카테고리',
    ));
    listViews.add(const CategoryView());
    listViews.add(TextView(title: 'AI 트레이너'));
    listViews.add(AiTrainerView());
    listViews.add(SizedBox(
      height: 16,
    ));
    listViews.add(TextView(title: '운동 트랙'));
    listViews.add(SizedBox(
      height: 12,
    ));
    listViews.add(const TrackView());
  }

  @override
  void initState() {
    addAllListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.chipBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listViews,
          ),
        ),
      ),
    );
  }
}
