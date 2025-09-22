import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/screens/new_entry/mood_selection_screen.dart";
import "package:emotiary/theme/app_colors.dart";
import "package:emotiary/theme/app_text_styles.dart";

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final PageController _pageController = PageController();

  int _currentPageIndex = 0;

  late MapEntry<String, String> mood;

  void _onPageChanged(int index) => setState(() => _currentPageIndex = index);

  void _goToNextPage() => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  void _goToPreviousPage() => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      MoodSelectionScreen(
        onFinished: (MapEntry<String, String> mood) {
          setState(() => this.mood = mood);
          _goToNextPage();
        }
      ),
      SizedBox(),
      SizedBox()
    ];

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: Padding(
          padding: const EdgeInsetsGeometry.only(left: 16),
          child: IconButton(
            icon: const Icon(AntDesign.left_outline, color: AppColors.darkBrown),
            onPressed: () {
              if (_currentPageIndex > 0) {
                _goToPreviousPage();
              } else {
                Navigator.of(context).pop();
              }
            }
          )
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsGeometry.only(right: 32),
            child: Text("${_currentPageIndex + 1} of ${screens.length}", style: AppTextStyles.bodyLarge)
          )
        ]
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: _onPageChanged,
        children: screens
      ),
    );
  }
}
