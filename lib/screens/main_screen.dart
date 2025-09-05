import "package:flutter/material.dart";
import "package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart";
import 'package:sliding_up_panel/sliding_up_panel.dart';
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
  final PanelController _panelController = PanelController();

  final Map<String, IconData> _icons = {
    "Home": Icons.home,
    "Insights": Icons.bar_chart_rounded
  };

  int _bottomNavIndex = 0;
  
  List<Entry> _entries = [];
  Widget _slidingPanelContent = SizedBox.shrink();

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

  void _onOpenPanel(Widget panelContent) {
    setState(() => _slidingPanelContent = panelContent);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(entries: _entries, panelController: _panelController, onOpenPanel: _onOpenPanel),
              InsightsScreen()
            ]
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(32)),
            onPressed: _goToNewEntryScreen,
            child: Icon(Icons.edit_rounded)
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: _icons.length,
            activeIndex: _bottomNavIndex,
            notchMargin: 0,
            gapLocation: GapLocation.center,
            backgroundColor: AppColors.beige,
            splashColor: Colors.transparent,
            tabBuilder: (int index, bool isActive) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  Icon(_icons.values.elementAt(index), size: 30, color: isActive ? AppColors.veryDarkBrown : Colors.grey),
                  Text(_icons.keys.elementAt(index), style: TextStyle(fontSize: 12, color: isActive ? AppColors.veryDarkBrown : Colors.grey))
                ]
              );
            },
            onTap: (int index) {
              setState(() => _bottomNavIndex = index);
              _pageController.animateToPage(_bottomNavIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
            }
          )
        ),
        SlidingUpPanel(
          controller: _panelController,
          minHeight: 0,
          maxHeight: 700,
          backdropEnabled: true,
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          panel: _slidingPanelContent
        )
      ]
    );
  }
}
