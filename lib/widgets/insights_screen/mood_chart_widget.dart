import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:emotiary/models/entry.dart';
import "package:emotiary/theme/app_colors.dart";
import "package:emotiary/utils/date_time_utils.dart";

class MoodChartPoint {
  String day;
  int amount;

  MoodChartPoint(this.day, this.amount);
}

class MoodChartWidget extends StatelessWidget {
  static const List<String> _days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  static const List<String> _moods = ["Happy", "Calm", "Meh", "Down", "Awful"];
  static const List<Color> _moodColors = [ Colors.green, Colors.lightGreen, Colors.yellow, Colors.orange, Colors.red ];

  final Map<String, List<MoodChartPoint>> _moodChartData = {
    for (var mood in _moods)
      mood: [for (var day in _days) MoodChartPoint(day, 0)]
  };

  final String weekStart = DateFormat("MMM d").format(DateTimeUtils.getWeekStart());
  final String weekEnd = DateFormat("MMM d").format(DateTimeUtils.getWeekEnd());

  final List<Entry> entries;

  MoodChartWidget({ super.key, required this.entries });

  void _updateMoodChartData() {
    for (List<MoodChartPoint> moodChartPoints in _moodChartData.values) {
      for (MoodChartPoint moodData in moodChartPoints) {
        moodData.amount = 0;
      }
    }

    final Iterable<Entry> currentWeekEntries = entries.where(
      (Entry entry) => DateTimeUtils.isInCurrentWeek(DateTimeUtils.unformatDate(entry.date))
    );

    for (Entry entry in currentWeekEntries) {
      final List<MoodChartPoint>? moodChartPoints = _moodChartData[entry.mood];
      if (moodChartPoints == null) continue;

      for (MoodChartPoint moodChartPoint in moodChartPoints) {
        if (!entry.date.contains(moodChartPoint.day)) continue;
        moodChartPoint.amount++;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateMoodChartData();
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(side: BorderSide(width: 1, color: AppColors.tan),borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: SizedBox(
        width: 300,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Weekly Mood Chart", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.veryDarkBrown)),
                  Text("$weekStart - $weekEnd", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.sienna))
                ]
              )
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    axisLine: AxisLine(width: 0),
                    majorGridLines: MajorGridLines(width: 0),
                    labelStyle: TextStyle(color: AppColors.brown, fontSize: 14)
                  ),
                  primaryYAxis: NumericAxis(
                    interval: 1,
                    axisLine: AxisLine(width: 0),
                    majorGridLines: MajorGridLines(width: 0),
                    labelStyle: TextStyle(color: AppColors.brown, fontSize: 14)
                  ),
                  legend: Legend(
                    isVisible: true,
                    alignment: ChartAlignment.center,
                    position: LegendPosition.bottom,
                    orientation: LegendItemOrientation.horizontal,
                    overflowMode: LegendItemOverflowMode.scroll,
                    shouldAlwaysShowScrollbar: true,
                    padding: 7.5,
                    itemPadding: 10,
                    textStyle: TextStyle(fontSize: 12)
                  ),
                  plotAreaBorderWidth: 0,
                  series: _moodChartData.entries.toList().asMap().entries.map((MapEntry entry) {
                    final int index = entry.key;
                    final String moodName = entry.value.key;
                    final List<MoodChartPoint> points = entry.value.value;
                    final Color moodColor = _moodColors[index];

                    return AreaSeries<MoodChartPoint, String>(
                      name: moodName,
                      dataSource: points,
                      xValueMapper: (point, _) => point.day,
                      yValueMapper: (point, _) => point.amount,
                      color: moodColor.withValues(alpha: 0.5),
                      borderColor: moodColor,
                      borderWidth: 0,
                    );
                  }).toList()
                )
              )
            )
          ]
        )
      )
    );
  }
}
