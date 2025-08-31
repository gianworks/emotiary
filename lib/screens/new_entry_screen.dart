import "package:emotiary/theme/app_colors.dart";
import "package:flutter/material.dart";
import "package:emotiary/widgets/new_entry/mood_select_widget.dart";
import "package:emotiary/utils/date_time_utils.dart";

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _dateTextController = TextEditingController();

  final Map<String, String> _moods = {
    "Happy": "😄",
    "Calm": "😊",
    "Meh": "😐",
    "Down": "☹️",
    "Awful": "😞",
  };

  int _currentPage = 0;
  String _selectedMood = "";

  @override
  void initState() {
    super.initState();
    _dateTextController.text = DateTimeUtils.formatDate(DateTime.now());
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _dateTextController.dispose();
  }

  Future<void> _onSelectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );

    if (selectedDate == null) return;
    _dateTextController.text = DateTimeUtils.formatDate(selectedDate);
  }

  void _onSelectMood(String mood) {
    setState(() => _selectedMood = mood);
  }

  void _goToNextPage (bool condition) {
    if (!condition) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  void _goToPreviousPage(bool condition) {
    if (!condition) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  bool _canShowDoneButton() {
    switch (_currentPage) {
      case 0:
        return _selectedMood.isNotEmpty;
      case 1:
        return false;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: (_currentPage <= 0),
      onPopInvokedWithResult: (didPop, _) => _goToPreviousPage(!didPop),
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Entry"),
          actions: [
            Padding(
              padding: EdgeInsetsGeometry.only(right: 16),
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                offset: (_canShowDoneButton()) ? Offset(0, 0) : Offset(2, 0),
                child: TextButton.icon(
                  icon: Icon(Icons.check_circle_rounded, size: 24, color: AppColors.sienna),
                  label: Text("Done", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.sienna)),
                  onPressed: () => _goToNextPage(_canShowDoneButton())
                )
              )
            )
          ]
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: [
            MoodSelectWidget(
              dateTextController: _dateTextController, 
              moods: _moods, 
              selectedMood: _selectedMood, 
              onSelectDate: _onSelectDate, 
              onSelectMood: _onSelectMood
            ),
            Center(child: Text("Activity Select"))
          ]
        )
      )
    );
  }
}
