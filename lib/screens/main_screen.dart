import "package:flutter/material.dart";
import "package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart";
import "package:emotiary/theme/app_colors.dart";
import "package:emotiary/models/entry.dart";
import "package:emotiary/repositories/entry_repository.dart";
import "package:emotiary/screens/home_screen.dart";
import "package:emotiary/screens/new_entry_screen.dart";
import "package:emotiary/screens/insights_screen.dart";

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

  int _bottomNavIndex = 0;
  List<Entry> _entries = [];

  @override
  void initState() {
    super.initState();
    _entries = EntryRepository.getAllEntries();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _goToNewEntryScreen() async {
    final dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (_) => NewEntryScreen()));
    if (result == null) return;
    setState(() => _entries = EntryRepository.getAllEntries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(entries: _entries),
          InsightsScreen()
        ]
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(32)),
        onPressed: _goToNewEntryScreen,
        child: Icon(Icons.edit_rounded)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        height: 70,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        itemCount: _icons.length,
        activeIndex: _bottomNavIndex,  
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        borderColor: AppColors.tan,
        tabBuilder: (int index, bool isActive) {
          return Column(
            children: [
              const SizedBox(height: 20),
              Icon(_icons.values.elementAt(index), color: isActive ? AppColors.veryDarkBrown : Colors.grey),
              Text(_icons.keys.elementAt(index), style: TextStyle(fontSize: 14, color: isActive ? AppColors.veryDarkBrown : Colors.grey))
            ]
          );
        },
        onTap: (index) {
          setState(() => _bottomNavIndex = index);
          _pageController.animateToPage(_bottomNavIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      )
    );
  }
}
