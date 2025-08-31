import "package:flutter/material.dart";
import "package:emotiary/theme/app_colors.dart";
import "package:emotiary/screens/home_screen.dart";
import "package:emotiary/screens/new_entry_screen.dart";
import "package:emotiary/screens/insights_screen.dart";
import "package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();

  final Map<String, IconData> _icons = {
    "Home": Icons.home,
    "Insights": Icons.bar_chart_rounded
  };

  final List<Widget> _screens = [
    HomeScreen(),
    InsightsScreen()
  ];

  int _bottomNavIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _screens
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(32)),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NewEntryScreen())),
        child: Icon(Icons.edit_rounded)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        height: 64,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        itemCount: _icons.length,
        activeIndex: _bottomNavIndex,  
        tabBuilder: (int index, bool isActive) {
          return Column(
            children: [
              const SizedBox(height: 15),
              Icon(_icons.values.elementAt(index), color: isActive ? AppColors.veryDarkBrown : Colors.grey),
              Text(_icons.keys.elementAt(index), style: TextStyle(color: isActive ? AppColors.veryDarkBrown : Colors.grey))
            ]
          );
        },
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        onTap: (index) {
          setState(() => _bottomNavIndex = index);
          _pageController.animateToPage(_bottomNavIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      )
    );
  }
}
