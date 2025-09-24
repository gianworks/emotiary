import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/screens/new_entry/mood_selection_screen.dart";
import "package:emotiary/screens/new_entry/activity_selection_screen.dart";
import "package:emotiary/screens/new_entry/entry_writing_screen.dart";
import "package:emotiary/theme/app_colors.dart";
import "package:emotiary/theme/app_text_styles.dart";
import "package:emotiary/utils/date_time_utils.dart";
import "package:emotiary/utils/helpers/snack_bar_helper.dart";

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final PageController _pageController = PageController();

  int _currentPageIndex = 0;

  late MapEntry<String, String> _entryMood;
  late Map<String, String> _entryActivities;
  late String _entryDate, _entryTitleJson, _entryTextJson;

  void _onPageChanged(int index) => setState(() => _currentPageIndex = index);

  void _goToNextPage() => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  void _goToPreviousPage() {
    FocusScope.of(context).unfocus();
    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _saveNewEntry() {
    // TODO: Save the entry to a local database
    
    SnackBarHelper.show("Entry saved successfully.", context);
  }

  Future<void> _onDateSelect() async {
    DateTime? dateSelected = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );
    
    if (dateSelected == null) return;
    setState(() => _entryDate = DateTimeUtils.format(dateSelected));
  }

  @override
  void initState() {
    super.initState();
    _entryDate = DateTimeUtils.format(DateTime.now());
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      MoodSelectionScreen(
        onFinished: (MapEntry<String, String> selectedMood) {
          _entryMood = selectedMood;
          _goToNextPage();
        }
      ),
      ActivitySelectionScreen(
        onFinished: (Map<String, String> selectedActivities) {
          _entryActivities = selectedActivities;
          _goToNextPage();
        },
      ),
      EntryWritingScreen(
        isKeyboardShown: (MediaQuery.of(context).viewInsets.bottom > 0),
        onFinished: (titleJson, textJson) {
          _entryTitleJson = titleJson;
          _entryTextJson = textJson;
          _saveNewEntry();
          Navigator.of(context).pop();
        },
      )
    ];

    final bool isLastPage = (_currentPageIndex == screens.length - 1);
    final bool isNotFirstPage = (_currentPageIndex > 0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      color: (isLastPage) ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: Padding(
            padding: const EdgeInsetsGeometry.only(left: 16),
            child: IconButton(
              icon: const Icon(AntDesign.left_outline, color: AppColors.darkBrown),
              onPressed: () => (isNotFirstPage) ? _goToPreviousPage() : Navigator.of(context).pop()
            )
          ),
          centerTitle: true,
          title: (isLastPage) ? TextButton.icon(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.transparent),
            icon: Text(_entryDate, style: const TextStyle(fontSize: 16, color: AppColors.darkBrown, fontWeight: FontWeight.w500)),
            label: Icon(AntDesign.down_outline, size: 16, color: AppColors.darkBrown),
            onPressed: _onDateSelect,
          ) : null,
          actions: [
            Padding(
              padding: const EdgeInsetsGeometry.only(right: 32),
              child: Text("${_currentPageIndex + 1} of ${screens.length}", style: AppTextStyles.bodyLarge)
            )
          ]
        ),
        backgroundColor: Colors.transparent,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: _onPageChanged,
          children: screens
        )
      )
    );
  }
}
