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
        indicatorColor: Color.fromRGBO(255, 255, 255, 0),
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
            selectedIcon: Icon(
              IconData(0xf70c, fontFamily: 'Icon', fontPackage: null),
              color: Color.fromRGBO(80, 195, 134, 1),
            ),
            icon: Icon(IconData(0xf70c, fontFamily: 'Icon', fontPackage: null)),
            label: '운동',
          ),
          NavigationDestination(
              selectedIcon: Icon(
                  IconData(0xf022, fontFamily: 'Icon', fontPackage: null),
                  color: Color.fromRGBO(80, 195, 134, 1)),
              icon:
                  Icon(IconData(0xf022, fontFamily: 'Icon', fontPackage: null)),
              label: '기록'),
        ],
      ),
      body: buildScreen(),
    );
  }

  buildAppBar() {
    if (currentPageIndex == 0) {
      return AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child:
                Icon(IconData(0xf3ee, fontFamily: 'Icon', fontPackage: null)),
          )
        ],
        backgroundColor: AppTheme.chipBackground,
        surfaceTintColor: AppTheme.chipBackground,
        title: Text(
          '운동',
          style: AppTheme.textTheme.titleLarge,
        ),
        centerTitle: false,
      );
    } else if (currentPageIndex == 1) {
      return AppBar(
          backgroundColor: AppTheme.chipBackground,
          surfaceTintColor: AppTheme.chipBackground,
          title: Text(
            '기록',
            style: AppTheme.textTheme.headlineSmall,
          ));
    }
  }

  buildScreen() {
    if (currentPageIndex == 0) {
      return FitnessHomeScreen();
    } else if (currentPageIndex == 1) {
      return RecordHomeScreen();
    }
  }
}
