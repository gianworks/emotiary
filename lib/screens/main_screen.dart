import "package:flutter/material.dart";
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

  final List<IconData> _icons = [
    Icons.home,
    Icons.bar_chart_rounded
  ];

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
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _icons, 
        activeIndex: _bottomNavIndex, 
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
        onTap: (index) {
          setState(() => _bottomNavIndex = index);
          _pageController.animateToPage(_bottomNavIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      )
    );
  }
}
