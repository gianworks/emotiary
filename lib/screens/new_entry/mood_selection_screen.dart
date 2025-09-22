import "package:flutter/material.dart";
import "package:emotiary/theme/app_colors.dart";
import "package:emotiary/theme/app_text_styles.dart";
import "package:emotiary/widgets/primary_button.dart";

class MoodSelectionScreen extends StatefulWidget {
  final Function(MapEntry<String, String> selectedMood) onFinished;

  const MoodSelectionScreen({
    super.key,
    required this.onFinished
  });

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> with AutomaticKeepAliveClientMixin  {
  static const Map<String, String> _moods = {
    "Awful": "😞",
    "Down": "☹️",
    "Meh": "😐️",
    "Calm": "😊",
    "Happy": "😄"
  };

  int _currentSliderValue = 3;
  MapEntry<String, String> _selectedMood = _moods.entries.elementAt(2);

  void _onSliderValueChanged(double value) {
    setState(() {
      _currentSliderValue = value.round();
      _selectedMood = _moods.entries.elementAt(_currentSliderValue - 1);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 48),
        const Text("Hey user,\nhow are you feeling?", style: AppTextStyles.headlineLarge, textAlign: TextAlign.center),
        const SizedBox(height: 48),
        Text(_selectedMood.value, style: TextStyle(fontSize: 96), textAlign: TextAlign.center),
        Text("I'm feeling ${_selectedMood.key.toLowerCase()}", style: TextStyle(fontSize: 20, color: AppColors.darkBrown, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        const SizedBox(height: 32),
        Slider(
          value: _currentSliderValue.toDouble(), 
          min: 1,
          max: _moods.length.toDouble(),
          divisions: _moods.length - 1,
          activeColor: AppColors.brownSugar,
          onChanged: _onSliderValueChanged
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _moods.keys.map((String mood) => Text(mood, style: AppTextStyles.bodyLarge)).toList()
        ),
        const SizedBox(height: 48),
        PrimaryButton(
          label: "Continue", 
          onPressed: () => widget.onFinished(_selectedMood)
        )
      ]
    );
  }
}
