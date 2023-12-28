import 'package:ai_trainer_mypt/screens/record/record_home_screen.dart';
import 'package:ai_trainer_mypt/theme.dart';
import 'package:flutter/material.dart';

import 'account/account_home_screen.dart';
import 'fitness/fitness_home_screen.dart';

class MyptAppHomeScreen extends StatefulWidget {
  const MyptAppHomeScreen({super.key});

  @override
  State<MyptAppHomeScreen> createState() => _MyptAppHomeScreenState();
}

class _MyptAppHomeScreenState extends State<MyptAppHomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      bottomNavigationBar: NavigationBar(
        height: 60,
        surfaceTintColor: AppTheme.white,
        backgroundColor: AppTheme.white,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
              selectedIcon: Icon(Icons.run_circle),
              icon: Icon(Icons.run_circle_outlined),
              label: '운동'),
          NavigationDestination(
              selectedIcon: Icon(Icons.insert_chart),
              icon: Icon(Icons.insert_chart_outlined),
              label: '기록'),
          NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline),
              label: '나'),
        ],
      ),
      body: buildScreen(),
    );
  }

  buildAppBar() {
    if (currentPageIndex == 0) {
      return AppBar(
        backgroundColor: AppTheme.chipBackground,
        title: Text(
          '운동',
          style: AppTheme.textTheme.headlineSmall,
        ),
        centerTitle: false,
      );
    } else if (currentPageIndex == 1) {
      return AppBar(
          backgroundColor: AppTheme.chipBackground,
          title: Text(
            '기록',
            style: AppTheme.textTheme.headlineSmall,
          ));
    } else if (currentPageIndex == 2) {
      return AppBar(
          backgroundColor: AppTheme.chipBackground,
          title: Text('내 정보', style: AppTheme.textTheme.headlineSmall));
    }
  }

  buildScreen() {
    if (currentPageIndex == 0) {
      return FitnessHomeScreen();
    } else if (currentPageIndex == 1) {
      return RecordHomeScreen();
    } else if (currentPageIndex == 2) {
      return AccountHomeScreen();
    }
  }
}
