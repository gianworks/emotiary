import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/data/models/entry.dart";
import "package:emotiary/data/repositories/entry_repository.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/core/utils/date_time_utils.dart";
import "package:emotiary/core/helpers/snack_bar_helper.dart";
import "package:emotiary/screens/new_entry/mood_selection_screen.dart";
import "package:emotiary/screens/new_entry/activity_selection_screen.dart";
import "package:emotiary/screens/new_entry/entry_writing_screen.dart";

class NewEntryScreen extends StatefulWidget {
  final Entry? entry;

  const NewEntryScreen({super.key, this.entry});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final PageController _pageController = PageController();

  int _currentPageIndex = 0;

  late Map<String, String> _entryActivities;
  late String _entryDate, _entryMood, _entryMoodEmoji, _entryTitleJson, _entryTextJson;

  void _onPageChanged(int index) => setState(() => _currentPageIndex = index);

  void _goToNextPage() => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  
  void _goToPreviousPage() {
    FocusScope.of(context).unfocus();
    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<void> _onSelectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );
    
    if (selectedDate == null) return;
    setState(() => _entryDate = DateTimeUtils.format(selectedDate));
  }

  void _saveEntry() async {
    if (widget.entry == null) {
      final Entry newEntry = Entry(
        date: _entryDate,
        mood: _entryMood,
        moodEmoji: _entryMoodEmoji,
        activities: _entryActivities,
        titleJson: _entryTitleJson,
        textJson: _entryTextJson,
      );
      await EntryRepository.add(newEntry);
      if (!mounted) return;
      SnackBarHelper.show("Entry created successfully.", context);
    } else {
      widget.entry!
        ..date = _entryDate
        ..mood = _entryMood
        ..moodEmoji = _entryMoodEmoji
        ..activities = _entryActivities
        ..titleJson = _entryTitleJson
        ..textJson = _entryTextJson;
      await widget.entry!.save();
      if (!mounted) return;
      SnackBarHelper.show("Entry updated successfully.", context);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _entryDate = widget.entry!.date;
      _entryMood = widget.entry!.mood;
      _entryMoodEmoji = widget.entry!.moodEmoji;
      _entryActivities = widget.entry!.activities;
      _entryTitleJson = widget.entry!.titleJson;
      _entryTextJson = widget.entry!.textJson;
    } else {
      _entryDate = DateTimeUtils.format(DateTime.now());
      _entryActivities = {};
      _entryMood = "";
      _entryMoodEmoji = "";
      _entryTitleJson = "";
      _entryTextJson = "";
    }
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
        existingMood: (widget.entry != null) ? _entryMood : null,
        onFinished: (String selectedMood, String selectedMoodEmoji) {
          _entryMood = selectedMood;
          _entryMoodEmoji = selectedMoodEmoji;
          _goToNextPage();
        }
      ),
      ActivitySelectionScreen(
        existingActivities: (widget.entry != null) ? _entryActivities : null,
        onFinished: (Map<String, String> selectedActivities) {
          _entryActivities = selectedActivities;
          _goToNextPage();
        },
      ),
      EntryWritingScreen(
        entryTitleJson: (widget.entry != null) ? _entryTitleJson : null,
        entryTextJson: (widget.entry != null) ? _entryTextJson : null,
        isKeyboardVisible: (MediaQuery.of(context).viewInsets.bottom > 0),
        onFinished: (String titleJson, String textJson) {
          _entryTitleJson = titleJson;
          _entryTextJson = textJson;
          _saveEntry();
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
            onPressed: _onSelectDate,
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
