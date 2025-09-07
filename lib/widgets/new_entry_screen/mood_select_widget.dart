import "package:flutter/material.dart";
import "package:emotiary/theme/app_colors.dart";
import "package:emotiary/utils/date_time_utils.dart";

class MoodSelectWidget extends StatelessWidget {
  final Map<String, String> _moods = {
    "Happy": "😄",
    "Calm": "😊",
    "Meh": "😐",
    "Down": "☹️",
    "Awful": "😞",
  };

  final TextEditingController dateTextController;
  final String selectedMood;

  final Function(String mood, String moodEmoji) onSelectMood;

  MoodSelectWidget({ super.key, required this.dateTextController, required this.selectedMood, required this.onSelectMood });

  Future<void> _onSelectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (selectedDate == null) return;
    dateTextController.text = DateTimeUtils.formatDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 170),
        SizedBox(
          width: 210,
          child: TextField(
            controller: dateTextController,
            readOnly: true,
            enableInteractiveSelection: false,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.saddleBrown),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.date_range_rounded, color: AppColors.saddleBrown),
              suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.saddleBrown),
              prefixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 32),
              suffixIconConstraints: BoxConstraints(minHeight: 16, minWidth: 16)
            ),
            onTap: () => _onSelectDate(context)
          )
        ),
        const SizedBox(height: 20),
        Text("How are you feeling?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.veryDarkBrown)),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: _moods.entries.map((MapEntry<String, String> mapEntry) {
            final String mood = mapEntry.key;
            final String moodEmoji = mapEntry.value;
            final bool isSelected = selectedMood == mood;

            return GestureDetector(
              onTap: () => onSelectMood(mood, moodEmoji),
              child: AnimatedOpacity(
                opacity: (isSelected) ? 1 : 0.5,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 300),
                child: AnimatedScale(
                  scale: (isSelected) ? 1.1 : 1,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Text(moodEmoji, style: TextStyle(fontSize: 42)),
                      Text(mood, style: TextStyle(fontSize: 16, color: AppColors.brown))
                    ]
                  )
                )
              )
            );
          }).toList()
        )
      ]
    );
  }
}
