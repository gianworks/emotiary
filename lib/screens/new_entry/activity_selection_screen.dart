import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/core/helpers/snack_bar_helper.dart";
import "package:emotiary/widgets/primary_button.dart";

class ActivitySelectionScreen extends StatefulWidget {
  final Map<String, String>? existingActivities;
  final Function(Map<String, String> selectedActivities) onFinished;

  const ActivitySelectionScreen({
    super.key,
    this.existingActivities,
    required this.onFinished
  });

  @override
  State<ActivitySelectionScreen> createState() => _ActivitySelectionScreenState();
}

class _ActivitySelectionScreenState extends State<ActivitySelectionScreen> with AutomaticKeepAliveClientMixin {
  static const Map<String, String> _activities = {
    "Work": "💼",
    "Study": "📚",
    "Exercise": "🏃",
    "Travel": "✈️",
    "Social": "👥",
    "Relaxing": "🧘‍♀️",
    "Eating": "🍽️",
    "Chores": "🧹",
    "Creative": "🎨",
    "Media": "📱",
    "Nature": "🌳",
    "Other": "🎲"
  };

  Map<String, String> _selectedActivities = {};

  void _addActivity(MapEntry<String, String> activity) => setState(() => _selectedActivities.addEntries([activity]));
  void _removeActivity(MapEntry<String, String> activity) => setState(() => _selectedActivities.remove(activity.key));

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.existingActivities != null) {
      _selectedActivities = widget.existingActivities!;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 48),
        const Text("What are you up to?", style: AppTextStyles.headlineLarge, textAlign: TextAlign.center),
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 0.75,
            physics: const NeverScrollableScrollPhysics(),
            children: _activities.entries.map((MapEntry<String, String> activity) {
              final bool isSelected = _selectedActivities.containsKey(activity.key);

              return InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => (isSelected) ? _removeActivity(activity) : _addActivity(activity),
                child: Column(
                  children: [
                    Text(activity.value, style: TextStyle(fontSize: 32)),
                    SizedBox(height: 8),
                    Text(activity.key, style: AppTextStyles.bodyLarge),
                    SizedBox(height: 8),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (isSelected) ? AppColors.brownSugar : null,
                        border: Border.all(
                          width: 1,
                          color: (isSelected) ? AppColors.brownSugar : AppColors.darkBrown
                        )
                      ),
                      child: (isSelected) ? Icon(FontAwesome.check_solid, size: 10, color: Colors.white) : null
                    )
                  ]
                )
              );
            }).toList()
          )
        ),
        const SizedBox(height: 8),
        PrimaryButton(
          label: "Continue",
          onPressed: () => (_selectedActivities.isNotEmpty) ? widget.onFinished(
            _selectedActivities
          ) : SnackBarHelper.show("Please select at least one activity.", context)
        )
      ]
    );
  }
}