import "package:flutter/material.dart";
import "package:emotiary/theme/app_colors.dart";

class ActivitySelectWidget extends StatelessWidget {
  final Map<String, String> _activities = {
    "Work": "💼",
    "Exercise": "🏃",
    "Travel": "✈️",
    "Music": "🎵",
    "Nature": "🌳",
    "Gaming": "🎮",
    "Art": "🎨",
    "Relaxing": "🧘‍♀️",
    "Reading": "📚",
    "Eating": "🍽️",
    "Cooking": "🍳",
    "Watching": "🖥️",
    "Cleaning": "🧹",
    "Shopping": "🛍️",
    "Friends": "👥",
    "Other": "🚩"
  };

  final Map<String, String> selectedActivities;

  final Function(MapEntry<String, String> activity) onSelectActivity;
  final Function(MapEntry<String, String> activity) onUnselectActivity;

  ActivitySelectWidget({ 
    super.key,
    required this.selectedActivities, 
    required this.onSelectActivity,
    required this.onUnselectActivity
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Text("What have you been up to?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.veryDarkBrown)),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 0.75,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(30),
            children: _activities.entries.map((entry) {
              final String activity = entry.key;
              final String emoji = entry.value;
              final bool isSelected = selectedActivities.containsKey(activity);

              return GestureDetector(
                onTap: () => (!isSelected) ? onSelectActivity(entry) : onUnselectActivity(entry),
                child: Center(
                  child: AnimatedScale(
                    scale: (isSelected) ? 1.1 : 1,
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          width: 55,
                          height: 55,
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, 
                            color: (isSelected) ? AppColors.almond : Colors.white, 
                            border: Border.all(width: 1, color: AppColors.almond)
                          ),
                          child: Center(child: Text(emoji, style: TextStyle(fontSize: 32)))
                        ),
                        const SizedBox(height: 10),
                        Text(activity, style: TextStyle(fontSize: 16, color: AppColors.brown))
                      ]
                    )
                  )
                )
              );
            }).toList()
          )
        )
      ]
    );
  }
}
