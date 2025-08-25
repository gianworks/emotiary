import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:emotiary/Screens/new_entry_screen.dart';
import 'package:emotiary/Screens/view_entry_screen.dart';
import 'package:emotiary/Services/preferences_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> _entries;

  static const List<String> _days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  static const List<String> _moods = ["Happy", "Content", "Neutral", "Sad", "Very Sad"];

  final Map<String, List<MoodData>> _moodCharts = {
    for (var mood in _moods)
      mood: [for (var day in _days) MoodData(day, 0)]
  };

  @override
  void initState() {
    super.initState();
    _updateEntries();
  }

  void _updateEntries() => setState(() { 
    _entries = PreferencesService().getEntries();
    _updateMoodCharts(); 
  });

  void _deleteEntries() { 
    PreferencesService().deleteEntries(); 
    _updateEntries(); 
  }

  void _goToNewEntryScreen() async {
    final bool result = await Navigator.push(context, MaterialPageRoute(builder: (_) => NewEntryScreen()));
    if (result == false) return;
    _updateEntries();
  }

  void _goToViewEntryScreen(Map entry) async {
    final bool result = await Navigator.push(context, MaterialPageRoute(builder: (_) => ViewEntryScreen(entry: entry)));
    if (result == false) return;
    _updateEntries();
  }

  bool _isInCurrentWeek(String entryDate) {
    final DateTime parsedDate = DateFormat("EEEE, MMMM dd, yyyy").parse(entryDate);

    // Normalize (strip time)
    final DateTime givenDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    final DateTime today = DateTime.now();
    final DateTime refDate = DateTime(today.year, today.month, today.day);

    // Start of the week (Monday)
    final DateTime weekStart = refDate.subtract(Duration(days: refDate.weekday - DateTime.monday));

    // End of the week (Sunday)
    final DateTime weekEnd = weekStart.add(Duration(days: 6));

    return givenDate.isAfter(weekStart.subtract(Duration(seconds: 1))) && givenDate.isBefore(weekEnd.add(Duration(seconds: 1)));
  }

  void _updateMoodCharts() {
    // Reset all values
    for (var moodDataList in _moodCharts.values) {
      for (var moodData in moodDataList) {
        moodData.amount = 0;
      }
    }

    // Filter relevant entries (week only)
    final currentWeekEntries = _entries.where((entry) => _isInCurrentWeek(entry["date"]));

    // Update mood data amount
    for (var entry in currentWeekEntries) {
      final String entryMood = entry["mood"];
      final String entryDate = entry["date"];

      final List<MoodData>? moodDataList = _moodCharts[entryMood];
      if (moodDataList == null) continue;

      for (var moodData in moodDataList) {
        if (!entryDate.contains(moodData.day)) continue;
        moodData.amount++;
        break;
      }
    }
  }

  void _showDeleteEntriesDialog() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Delete Entries"),
        content: Text("Are you sure you want to delete all entries? This process cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, "Cancel"),
            child: Text("Cancel")
          ),
          TextButton(
            onPressed: () { _deleteEntries(); Navigator.pop(context, "Delete"); },
            child: Text("Delete")
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: _goToNewEntryScreen,
        child: Icon(Icons.edit, color: Colors.white)
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 50),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SfCartesianChart(
              title: ChartTitle(text: "Weekly Moods & Metrics"),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                orientation: LegendItemOrientation.horizontal,
                overflowMode: LegendItemOverflowMode.scroll
              ),
              primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0)
              ),
              primaryYAxis: NumericAxis(
                interval: 1,
                majorGridLines: MajorGridLines(width: 2)
              ),
              series: <CartesianSeries>[
                _moodSeries("Happy", Colors.green),
                _moodSeries("Content", Colors.lightGreen),
                _moodSeries("Neutral", Colors.yellow),
                _moodSeries("Sad", Colors.orange),
                _moodSeries("Very Sad", Colors.red)
              ]
            )
          ),
          
          const SizedBox(height: 20),
          
          Text("Saved Entries", style: TextStyle(fontSize: 21.5), textAlign: TextAlign.center),
          
          const SizedBox(height: 10),

          if (_entries.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _entries.length,
              itemBuilder: (BuildContext context, int index) {
                final int reverseIndex = _entries.length - 1 - index;
                final Map entry = _entries[reverseIndex];

                final String entryEmoji = entry["emoji"];
                final String entryTitle = entry["title"];
                final String entryBody = entry["body"];
                final String entryDate = entry["date"];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 28),
                  child: ListTile(
                    leading: Text(entryEmoji, style: TextStyle(fontSize: 30)),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(entryTitle, style: TextStyle(fontSize: 18)),
                        Text(entryBody, style: TextStyle(fontSize: 14.5), maxLines: 5, overflow: TextOverflow.ellipsis)
                      ]
                    ),
                    subtitle: Text("\n$entryDate", style: TextStyle(fontSize: 14.5)),
                    trailing: Icon(Icons.arrow_right_rounded, size: 38, color: Colors.grey),
                    onTap: () => _goToViewEntryScreen(entry)
                  )
                );
              }
            ),
            
            const SizedBox(height: 50),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: _showDeleteEntriesDialog,
                child: Text("Delete Entries", style: TextStyle(color: Colors.white))
              )
            )
          ]

          else ...[
            Text("😔", style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text("Your journal is feeling a little lonely..\nAdd your first entry!", style: TextStyle(fontSize: 14.5), textAlign: TextAlign.center)
          ]
        ]
      )
    );
  }

  AreaSeries _moodSeries(String mood, Color color) {
    return AreaSeries<MoodData, String>(
      name: mood,
      dataSource: _moodCharts[mood],
      xValueMapper: (MoodData mood, _) => mood.day, 
      yValueMapper: (MoodData mood, _) => mood.amount,
      color: color,
      opacity: 0.3,
      borderDrawMode: BorderDrawMode.all,
      borderColor: color,
      borderWidth: 3
    );
  }
}

class MoodData {
  String day;
  int amount;

  MoodData(this.day, this.amount);
}
