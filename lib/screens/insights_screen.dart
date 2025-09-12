import "package:flutter/material.dart";
import "package:emotiary/models/entry.dart";
import "package:emotiary/theme/app_colors.dart";
import "package:emotiary/widgets/insights_screen/mood_chart_widget.dart";

class InsightsScreen extends StatefulWidget {
  final List<Entry> entries;

  const InsightsScreen({ super.key, required this.entries });

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emotiary")),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 50),
          Text("Journal Insights", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.veryDarkBrown)),
          const SizedBox(height: 10),
          MoodChartWidget(entries: widget.entries)
        ]
      )
    );
  }
}
