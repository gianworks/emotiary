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
        const SizedBox(height: 200),
        SizedBox(
          width: 215,
          child: TextField(
            controller: dateTextController,
            readOnly: true,
            enableInteractiveSelection: false,
            style: TextStyle(fontSize: 16, color: AppColors.saddleBrown),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.date_range_rounded, color: AppColors.saddleBrown),
              suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.saddleBrown),
              suffixIconConstraints: BoxConstraints(minHeight: 12, minWidth: 12)
            ),
            onTap: onSelectDate
          )
        ),
        const SizedBox(height: 20),
        Text("How are you feeling?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
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
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: (isSelected) ? 1 : 0.5,
                child: Column(
                  children: [
                    _animateText(emoji, 48, 42, isSelected),
                    const SizedBox(height: 5),
                    _animateText(mood, 20, 16, isSelected, color: AppColors.brown)
                  ]
                )
              )
            );
          }).toList()
        )
      ]
    );
  }

  Widget _animateText(String text, double selectedSize, double normalSize, bool isSelected, {Color? color}) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      style: TextStyle(fontSize: isSelected ? selectedSize : normalSize, color: color),
      child: Text(text)
    );
  }
}
