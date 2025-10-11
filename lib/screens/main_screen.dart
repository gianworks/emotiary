import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/data/models/entry.dart";
import "package:emotiary/data/repositories/entry_repository.dart";
import "package:emotiary/data/repositories/username_repository.dart";
import "package:emotiary/services/openrouter_service.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/core/helpers/navigation_helper.dart";
import "package:emotiary/screens/new_entry_screen.dart";
import "package:emotiary/screens/welcome_screen.dart";
import "package:emotiary/screens/home_screen.dart";
import "package:emotiary/screens/insights_screen.dart";
import "package:emotiary/screens/reflection_screen.dart";
import "package:emotiary/screens/settings_screen.dart";
import "package:emotiary/widgets/bottom_app_bar_item.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Entry> _entries = EntryRepository.getAll();
  
  int _currentItemIndex = 0;
  String _reflectionText = "";

  void _saveUsername(String username) async {
    await UsernameRepository.saveUsername(username);
    setState(() {});
  }

  void _updateEntries() {
    setState(() => _entries = EntryRepository.getAll());
    _generateReflection();
  }

  void _deleteEntry(Entry entry) {
    entry.delete();
    _updateEntries();
  }

  void _deleteAllEntries() async {
    await EntryRepository.deleteAll();
    _updateEntries();
  }

  void _editEntry(Entry entry) async {
    final dynamic result = await NavigationHelper.push(NewEntryScreen(entry: entry), context);
    if (result == null) return;
    _updateEntries();
  }

  void _goToNewEntryScreen() async {
    final dynamic result = await NavigationHelper.push(NewEntryScreen(), context);
    if (result == null) return;
    _updateEntries();
  }

  void _setCurrentItemIndex(int index) => setState(() => _currentItemIndex = index);

  Future<void> _generateReflection() async {
    if (_entries.isEmpty) {
      setState(() => _reflectionText = "No reflection available.");
      return;
    }

    final prompt = buildReflectionPrompt(_entries);
    final aiResponse = await getOpenRouterResponse(prompt);
    setState(() => _reflectionText = aiResponse);
  }

  @override
  void initState() {
    super.initState();
    _generateReflection();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        entries: _entries,
        onDeleteEntry: _deleteEntry,
        onEditEntry: _editEntry,
      ),
      InsightsScreen(
        entries: _entries
      ),
      ReflectionScreen(
        reflectionText: _reflectionText,
      ),
      SettingsScreen(
        onSaveUsername: _saveUsername,
        onDeleteAll: _deleteAllEntries,
      )
    ];

    return (UsernameRepository.hasUsername()) ? Scaffold(
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
        heroTag: null,
        shape: const CircleBorder(),
        onPressed: _goToNewEntryScreen,
        child: const Icon(AntDesign.edit_fill)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(width: 70),
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
    ) : WelcomeScreen(onSaveUsername: _saveUsername);
  }
}
