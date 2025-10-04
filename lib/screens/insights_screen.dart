import "package:flutter/material.dart";
import "package:fl_chart/fl_chart.dart";
import "package:emotiary/data/models/entry.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/core/utils/date_time_utils.dart";
import "package:emotiary/widgets/primary_card.dart";

class InsightsScreen extends StatefulWidget {
  final List<Entry> entries;

  const InsightsScreen({
    super.key,
    required this.entries,
  });

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  static const _moodScores = {
    "Awful": 1,
    "Down": 2,
    "Meh": 3,
    "Calm": 4,
    "Happy": 5,
  };

  static const _moodEmojis = {
    "Awful": "😞",
    "Down": "☹️",
    "Meh": "😐️",
    "Calm": "😊",
    "Happy": "😄"
  };

  static const _moodColors = {
    "Awful": Colors.red,
    "Down": Colors.orange,
    "Meh": Colors.grey,
    "Calm": Colors.blue,
    "Happy": Colors.green,
  };

  Iterable<Entry> _getEntriesThisWeek() => widget.entries.where((entry) => DateTimeUtils.isInCurrentWeek(DateTimeUtils.parse(entry.date)));

  String _getMostOccurredMood() {
    if (widget.entries.isEmpty) return "";

    final Map<String, int> moodCount = {};

    for (var entry in _getEntriesThisWeek()) {
      moodCount[entry.mood] = (moodCount[entry.mood] ?? 0) + 1;
    }

    String mostOccurredMood = moodCount.keys.first;
    int maxCount = moodCount[mostOccurredMood]!;

    moodCount.forEach((mood, count) {
      if (count > maxCount) {
        mostOccurredMood = mood;
        maxCount = count;
      }
    });

    return mostOccurredMood;
  }

  MapEntry<String, String>? _getMostOccurredActivity() {
    if (widget.entries.isEmpty) return null;

    final Map<String, int> activityCount = {};
    final Map<String, String> activityEmoji = {};

    for (var entry in _getEntriesThisWeek()) {
      entry.activities.forEach((activityName, emoji) {
        activityCount[activityName] = (activityCount[activityName] ?? 0) + 1;
        activityEmoji[activityName] = emoji;
      });
    }

    String mostOccurredActivity = activityCount.keys.first;
    int maxCount = activityCount[mostOccurredActivity]!;

    activityCount.forEach((activity, count) {
      if (count > maxCount) {
        mostOccurredActivity = activity;
        maxCount = count;
      }
    });

    return MapEntry(mostOccurredActivity, activityEmoji[mostOccurredActivity]!);
  }

  @override
  Widget build(BuildContext context) {
    final List<Entry?> weekData = List.generate(7, (i) => null);
    for (var entry in _getEntriesThisWeek()) {
      final date = DateTimeUtils.parse(entry.date);
      int weekdayIndex = date.weekday - 1;
      weekData[weekdayIndex] = entry;
    }

    return ListView(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      physics: NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 32),
        Text("Journal Insights", style: AppTextStyles.headlineLarge),
        const SizedBox(height: 32),
        PrimaryCard(
          height: 256,
          padding: const EdgeInsets.all(24),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Weekly Mood Trends", style: TextStyle(fontSize: 20, color: AppColors.darkBrown, fontWeight: FontWeight.w500)),
              const SizedBox(height: 48),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 5,
                    minY: 0,
                    gridData: FlGridData(show: false, drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                            return Text(days[value.toInt()], style: AppTextStyles.bodyMedium);
                          }
                        )
                      )
                    ),
                    barGroups: List.generate(7, (index) {
                      final entry = weekData[index];
                      if (entry == null) {
                        return BarChartGroupData(x: index, barRods: [ BarChartRodData(toY: 0, color: Colors.transparent, width: 20) ]);
                      }
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: _moodScores[entry.mood]!.toDouble(),
                            color: _moodColors[entry.mood],
                            width: 20,
                            borderRadius: BorderRadius.circular(24),
                          )
                        ],
                        showingTooltipIndicators: [0],
                      );
                    }),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => Colors.transparent,
                        tooltipMargin: -8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final mood = weekData[group.x]!.mood;
                          return BarTooltipItem(_moodEmojis[mood] ?? "", const TextStyle(fontSize: 24));
                        }
                      )
                    )
                  )
                )
              )
            ]
          )
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PrimaryCard(
                height: 150,
                padding: const EdgeInsets.all(24),
                content: Column(
                  children: [
                    const Text("Your Mood This Week", style: TextStyle(fontSize: 16, color: AppColors.darkBrown, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(_moodEmojis[_getMostOccurredMood()] ?? "-", style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 8),
                        Text(_getMostOccurredMood(), style: TextStyle(fontSize: 20, color: AppColors.brownSugar, fontWeight: FontWeight.w600))
                      ]
                    )
                  ]
                )
              )
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryCard(
                height: 150,
                padding: const EdgeInsets.all(24),
                content: Column(
                  children: [
                    const Text("Your Weekly Activity", style: TextStyle(fontSize: 16, color: AppColors.darkBrown, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(_getMostOccurredActivity()?.value ?? "-", style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 8),
                        Text(_getMostOccurredActivity()?.key ?? "", style: TextStyle(fontSize: 20, color: AppColors.brownSugar, fontWeight: FontWeight.w600))
                      ]
                    )
                  ]
                )
              )
            )
          ]
        )
      ]
    );
  }
}
