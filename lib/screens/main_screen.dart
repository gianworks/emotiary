import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/data/models/entry.dart";
import "package:emotiary/data/repositories/entry_repository.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/core/helpers/navigation_helper.dart";
import "package:emotiary/screens/new_entry_screen.dart";
import "package:emotiary/screens/home_screen.dart";
import "package:emotiary/widgets/bottom_app_bar_item.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentItemIndex = 0;
  List<Entry> _entries = EntryRepository.getAll();

  void _updateEntries() => setState(() => _entries = EntryRepository.getAll());

  void _goToNewEntryScreen() async {
    final dynamic result = await NavigationHelper.push(NewEntryScreen(), context);
    if (result == null) return;
    _updateEntries();
  }

  void _setCurrentItemIndex(int index) => setState(() => _currentItemIndex = index);

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(entries: _entries),
      SizedBox(),
      SizedBox(),
      SizedBox()
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Row(
          children: [
            Icon(AntDesign.book_outline, color: AppColors.darkBrown),
            SizedBox(width: 4),
            Text("Emotiary", style: AppTextStyles.titleMedium)
          ]
        )
      ),
      body: screens[_currentItemIndex],
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: _goToNewEntryScreen,
        child: const Icon(AntDesign.edit_fill)
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
              currentNavIndex: _currentItemIndex,
              selectedIcon: AntDesign.home_fill,
              unselectedIcon: AntDesign.home_outline,
              label: "Home", 
              onTap: _setCurrentItemIndex
            ),
            BottomAppBarItem(
              index: 1,
              currentNavIndex: _currentItemIndex,
              selectedIcon: AntDesign.pie_chart_fill, 
              unselectedIcon: AntDesign.pie_chart_outline, 
              label: "Insights", 
              onTap: _setCurrentItemIndex
            ),
            const SizedBox(width: 50),
            BottomAppBarItem(
              index: 2,
              currentNavIndex: _currentItemIndex,
              selectedIcon: AntDesign.read_fill, 
              unselectedIcon: AntDesign.read_outline, 
              label: "Reflection", 
              onTap: _setCurrentItemIndex
            ),
            BottomAppBarItem(
              index: 3,
              currentNavIndex: _currentItemIndex,
              selectedIcon: AntDesign.setting_fill, 
              unselectedIcon: AntDesign.setting_outline, 
              label: "Settings", 
              onTap: _setCurrentItemIndex
            )
          ]
        )
      )
    );
  }
}
