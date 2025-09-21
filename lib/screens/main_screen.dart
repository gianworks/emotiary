import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/widgets/bottom_app_bar_item.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentNavIndex = 0;

  final List<Widget> screens = [
    SizedBox(),
    SizedBox(),
    SizedBox(),
    SizedBox()
  ];

  void _onItemTap(int index) {
    setState(() => _currentNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentNavIndex],
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {},
        child: Icon(AntDesign.edit_fill)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomAppBarItem(
              index: 0,
              currentNavIndex: _currentNavIndex,
              selectedIcon: AntDesign.home_fill,
              unselectedIcon: AntDesign.home_outline,
              label: "Home", 
              onTap: _onItemTap
            ),
            BottomAppBarItem(
              index: 1,
              currentNavIndex: _currentNavIndex,
              selectedIcon: AntDesign.pie_chart_fill, 
              unselectedIcon: AntDesign.pie_chart_outline, 
              label: "Insights", 
              onTap: _onItemTap
            ),
            const SizedBox(width: 50),
            BottomAppBarItem(
              index: 2,
              currentNavIndex: _currentNavIndex,
              selectedIcon: AntDesign.read_fill, 
              unselectedIcon: AntDesign.read_outline, 
              label: "Reflection", 
              onTap: _onItemTap
            ),
            BottomAppBarItem(
              index: 3,
              currentNavIndex: _currentNavIndex,
              selectedIcon: AntDesign.setting_fill, 
              unselectedIcon: AntDesign.setting_outline, 
              label: "Settings", 
              onTap: _onItemTap
            )
          ]
        )
      )
    );
  }
}
