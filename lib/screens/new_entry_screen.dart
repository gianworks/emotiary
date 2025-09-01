import "package:flutter/material.dart";
import "package:flutter_quill/flutter_quill.dart";
import "package:emotiary/theme/app_colors.dart";
import "package:emotiary/utils/date_time_utils.dart";
import "package:emotiary/widgets/new_entry/mood_select_widget.dart";
import "package:emotiary/widgets/new_entry/activity_select_widget.dart";
import "package:emotiary/widgets/new_entry/note_write_widget.dart";

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _dateTextController = TextEditingController();
  final QuillController _titleQuillController = QuillController.basic();
  final QuillController _noteQuillControler = QuillController.basic();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();

  final int _lastPage = 2;
  final Map<String, String> _selectedActivities = {};

  int _currentPage = 0;
  String _selectedMood = "";

  @override
  void initState() {
    super.initState();
    _dateTextController.text = DateTimeUtils.formatDate(DateTime.now());

    _titleFocusNode.addListener(() => setState(() {}));
    _noteFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _dateTextController.dispose();
    _titleQuillController.dispose();
    _noteQuillControler.dispose();
  }

  void _onSelectMood(String mood) {
    setState(() => _selectedMood = mood);
  }

  void _onSelectActivity(MapEntry<String, String> entry) {
    setState(() => _selectedActivities.addEntries([entry]));
  }

  void _onUnselectActivity(MapEntry<String, String> entry) {
    setState(() => _selectedActivities.remove(entry.key));
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

  void _saveEntry() {
    // Save entry and its details to a database here
  }

  bool _canShowDoneButton() {
    switch (_currentPage) {
      case 0:
        return _selectedMood.isNotEmpty;
      case 1:
        return _selectedActivities.isNotEmpty;
      case 2:
        return _titleQuillController.document.toPlainText().trim().isNotEmpty && _noteQuillControler.document.toPlainText().trim().isNotEmpty;
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
                  icon: Icon((_currentPage < _lastPage) ? Icons.check_circle_rounded : Icons.save_rounded, size: 24, color: AppColors.sienna),
                  label: Text((_currentPage < _lastPage) ? "Done" : "Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.sienna)),
                  onPressed: () => (_currentPage < _lastPage) ? _goToNextPage(_canShowDoneButton()) : _saveEntry()
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
              selectedMood: _selectedMood, 
              onSelectMood: _onSelectMood
            ),
            ActivitySelectWidget(
              selectedActivities: _selectedActivities,
              onSelectActivity: _onSelectActivity,
              onUnselectActivity: _onUnselectActivity
            ),
            NoteWriteWidget(
              titleQuillController: _titleQuillController,
              noteQuillController: _noteQuillControler,
              titleFocusNode: _titleFocusNode,
              noteFocusNode: _noteFocusNode,
              isKeyboardUp: MediaQuery.of(context).viewInsets.bottom > 0
            )
          ]
        )
      )
    );
  }
}
