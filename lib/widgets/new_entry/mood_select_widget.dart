import "package:flutter/material.dart";
import "package:emotiary/theme/app_colors.dart";

class MoodSelectWidget extends StatelessWidget {
  final TextEditingController dateTextController;
  final Map<String, String> moods;
  final String selectedMood;

  final VoidCallback onSelectDate;
  final Function(String mood) onSelectMood;

  const MoodSelectWidget({ 
    super.key, 
    required this.dateTextController, 
    required this.moods,
    required this.selectedMood,
    required this.onSelectDate,
    required this.onSelectMood 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 170),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.date_range_rounded, color: AppColors.saddleBrown),
            SizedBox(
              width: 160,
              child: TextField(
                controller: dateTextController,
                readOnly: true,
                enableInteractiveSelection: false,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: InputBorder.none),
                style: TextStyle(fontSize: 16, color: AppColors.saddleBrown),
                onTap: onSelectDate
              )
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.saddleBrown)
          ]
        ),
        const SizedBox(height: 20),
        Text("How are you feeling?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.veryDarkBrown)),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: moods.entries.map((entry) {
            final String mood = entry.key;
            final String emoji = entry.value;
            final bool isSelected = selectedMood == mood;

            return GestureDetector(
              onTap: () => onSelectMood(mood),
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
                      Text(emoji, style: TextStyle(fontSize: 42)),
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
