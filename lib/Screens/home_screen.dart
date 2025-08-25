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

class MoodData {
  String day;
  int amount;

  MoodData(this.day, this.amount);
}

class _HomeScreenState extends State<HomeScreen> {
  
  List<dynamic> _entries = [];

  final Map<String, List<MoodData>> _moodCharts = {
    "Happy": [
      MoodData("Mon", 0),
      MoodData("Tue", 0),
      MoodData("Wed", 0),
      MoodData("Thu", 0),
      MoodData("Fri", 0),
      MoodData("Sat", 0),
      MoodData("Sun", 0),
    ],
    "Content": [
      MoodData("Mon", 0),
      MoodData("Tue", 0),
      MoodData("Wed", 0),
      MoodData("Thu", 0),
      MoodData("Fri", 0),
      MoodData("Sat", 0),
      MoodData("Sun", 0),
    ],
    "Neutral": [
      MoodData("Mon", 0),
      MoodData("Tue", 0),
      MoodData("Wed", 0),
      MoodData("Thu", 0),
      MoodData("Fri", 0),
      MoodData("Sat", 0),
      MoodData("Sun", 0),
    ],
    "Sad": [
      MoodData("Mon", 0),
      MoodData("Tue", 0),
      MoodData("Wed", 0),
      MoodData("Thu", 0),
      MoodData("Fri", 0),
      MoodData("Sat", 0),
      MoodData("Sun", 0),
    ],
    "Very Sad": [
      MoodData("Mon", 0),
      MoodData("Tue", 0),
      MoodData("Wed", 0),
      MoodData("Thu", 0),
      MoodData("Fri", 0),
      MoodData("Sat", 0),
      MoodData("Sun", 0),
    ]
  };

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

    return givenDate.isAfter(weekStart.subtract(Duration(seconds: 1))) &&
          givenDate.isBefore(weekEnd.add(Duration(seconds: 1)));
  }

  void _updateMoodCharts() {
    _moodCharts.forEach((mood, moodDataList) {
      for (var moodData in moodDataList) {
        setState(() => moodData.amount = 0);
      }

      for (var entry in _entries) {
        if (entry["mood"] != mood || !_isInCurrentWeek(entry["date"])) continue;

        for (var moodData in moodDataList) {
          if (!entry["date"].contains(moodData.day)) continue;
          setState(() => moodData.amount++);
        }
      }
    });
  }

  void _goToNewEntry() async {
    final bool result = await Navigator.push(
      context, MaterialPageRoute(builder: (_) => NewEntryScreen())
    );
    if (result == false) return;
    _updateEntries();
  }

  void _goToViewEntry(Map entry) async {
    final bool result = await Navigator.push(
      context, MaterialPageRoute(builder: (_) => ViewEntryScreen(entry: entry))
    );
    if (result == false) return;
    _updateEntries();
  }

  void _updateEntries() {
    setState(() => _entries = PreferencesService().getEntries());
    _updateMoodCharts();
  }

  void _deleteEntries() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Delete Entries"),
        content: Text("Are you sure you want to delete all entries? This process cannot be undone."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, "Cancel");
            },
            child: Text("Cancel")
          ),
          TextButton(
            onPressed: () {
              PreferencesService().deleteEntries();
              _updateEntries();
              Navigator.pop(context, "Delete");
            },
            child: Text("Delete")
          ),
        ]
      )
    );
  }

  @override
  void initState() 
  {
    super.initState();
    _updateEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _goToNewEntry,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(Icons.add, color: Colors.white)
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SfCartesianChart(
              title: ChartTitle(text: "Weekly Moods & Metrics"),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                orientation: LegendItemOrientation.horizontal,
                overflowMode: LegendItemOverflowMode.scroll
              ),
              primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                interval: 1,
                majorGridLines: MajorGridLines(
                  width: 1,
                  color: Color.fromARGB(50, 0, 0, 0)
                )
              ),
              series: <CartesianSeries>[
                AreaSeries<MoodData, String>(
                  name: "Happy",
                  dataSource: _moodCharts["Happy"],
                  xValueMapper: (MoodData mood, _) => mood.day, 
                  yValueMapper: (MoodData mood, _) => mood.amount,
                  color: Colors.green,
                  opacity: 0.3,
                  borderDrawMode: BorderDrawMode.all,
                  borderColor: Colors.green,
                  borderWidth: 3
                ),
                AreaSeries<MoodData, String>(
                  name: "Content",
                  dataSource: _moodCharts["Content"],
                  xValueMapper: (MoodData mood, _) => mood.day, 
                  yValueMapper: (MoodData mood, _) => mood.amount,
                  color: Color.fromARGB(255, 143, 224, 11),
                  opacity: 0.3,
                  borderDrawMode: BorderDrawMode.all,
                  borderColor: Color.fromARGB(255, 143, 224, 11),
                  borderWidth: 3
                ),
                AreaSeries<MoodData, String>(
                  name: "Neutral",
                  dataSource: _moodCharts["Neutral"],
                  xValueMapper: (MoodData mood, _) => mood.day, 
                  yValueMapper: (MoodData mood, _) => mood.amount,
                  color: Color.fromARGB(255, 199, 211, 27),
                  opacity: 0.3,
                  borderDrawMode: BorderDrawMode.all,
                  borderColor: Color.fromARGB(255, 199, 211, 27),
                  borderWidth: 3
                ),
                AreaSeries<MoodData, String>(
                  name: "Sad",
                  dataSource: _moodCharts["Sad"],
                  xValueMapper: (MoodData mood, _) => mood.day, 
                  yValueMapper: (MoodData mood, _) => mood.amount,
                  color: Color.fromARGB(255, 206, 132, 22),
                  opacity: 0.3,
                  borderDrawMode: BorderDrawMode.all,
                  borderColor: Color.fromARGB(255, 206, 132, 22),
                  borderWidth: 3
                ),
                AreaSeries<MoodData, String>(
                  name: "Very Sad",
                  dataSource: _moodCharts["Very Sad"],
                  xValueMapper: (MoodData mood, _) => mood.day, 
                  yValueMapper: (MoodData mood, _) => mood.amount,
                  color: Color.fromARGB(255, 206, 59, 22),
                  opacity: 0.3,
                  borderDrawMode: BorderDrawMode.all,
                  borderColor: Color.fromARGB(255, 206, 59, 22),
                  borderWidth: 3
                )
              ],
            ),
          ),

          SizedBox(height: 30),

          Column(
            children: [
              Text("Saved Entries", style: TextStyle(fontSize: 21)),
              SizedBox(height: 10),
              if (_entries.isNotEmpty) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _entries.length,
                  itemBuilder: (context, index) {
                    final int reverseIndex = _entries.length - 1 - index;
                    final Map entry = _entries[reverseIndex];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: ListTile(
                        leading: Text(entry["emoji"], style: TextStyle(fontSize: 30)),
                        title: Text(entry["title"]),
                        subtitle: Text("${entry["date"]}"),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () => _goToViewEntry(entry)
                      ),
                    );
                  }
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _deleteEntries,
                  child: Text("Delete Entries"),
                )
              ]
              else ...[
                Center(child: Text("😔", style: TextStyle(fontSize: 21))),
                Center(child: Text("Your journal is feeling a little lonely..")),
                Center(child: Text("Add your first entry!"))
              ]
            ]
          )
        ],
      )
    );
  }
}

