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
    "Reading": "📖",
    "Studying": "📚",
    "Writing": "✍️",
    "Shopping": "🛍️",
    "Cooking": "🍳",
    "Eating": "🍽️",
    "Watching": "🖥️",
    "Other": "🚩",
  };

  final Map<String, String> selectedActivities;

  final Function(MapEntry<String, String> activity) onSelectActivity;
  final Function(MapEntry<String, String> activity) onUnselectActivity;

  ActivitySelectWidget({ super.key, required this.selectedActivities, required this.onSelectActivity, required this.onUnselectActivity});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 150),
          Text("What have you been up to?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.veryDarkBrown)),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            childAspectRatio: 0.7,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: _activities.entries.map((entry) {
              final String activity = entry.key;
              final String emoji = entry.value;
              final bool isSelected = selectedActivities.containsKey(activity);

              return GestureDetector(
                onTap: () => (!isSelected) ? onSelectActivity(entry) : onUnselectActivity(entry),
                child: AnimatedScale(
                  scale: (isSelected) ? 1.05 : 1,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        width: 50,
                        height: 50,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, 
                          color: (isSelected) ? AppColors.almond : AppColors.beige, 
                          border: Border.all(width: 1, color: (isSelected) ? AppColors.sienna : AppColors.almond)
                        ),
                        child: Center(child: Text(emoji, style: TextStyle(fontSize: 24)))
                      ),
                      const SizedBox(height: 7.5),
                      Text(activity, style: TextStyle(fontSize: 14, color: AppColors.brown))
                    ]
                  )
                )
              );
            }).toList()
          )
        ]
      )
    );
  }
}
