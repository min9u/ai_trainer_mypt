import 'package:flutter/material.dart';

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
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.run_circle),
            icon: Icon(Icons.run_circle_outlined),
            label: '운동'
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.insert_chart),
            icon: Icon(Icons.insert_chart_outlined),
            label: '기록'
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: '나'
          ),
        ],
      ),
    );
  }

  buildAppBar(){
    if(currentPageIndex==0){
      return AppBar(title: Text('운동'),);
    }else if(currentPageIndex==1){
      return AppBar(title: Text('기록'));
    }else if(currentPageIndex==2){
      return AppBar(title: Text('내 정보'));
    }
  }
}