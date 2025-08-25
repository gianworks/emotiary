import 'package:emotiary/Services/preferences_service.dart';
import 'package:flutter/material.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {

  final PageController _pageController = PageController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  final Map<String, String> _moods = {
    "😄": "Happy",
    "😊": "Content",
    "😐": "Neutral",
    "☹️": "Sad",
    "😭": "Very Sad",
  };

  String _selectedMood = "";  

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 500), 
      curve: Curves.easeInOut
    );
  }

  Future<void> _selectDate() async {
    DateTime? dateTime = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100));

    if (dateTime == null || !mounted) return;

    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String formattedDateTime = localizations.formatFullDate(dateTime);

    setState(() => _dateController.text = formattedDateTime);
  }

  Future<void> _selectTime() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now());

    if (timeOfDay == null || !mounted) return;

    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String formattedTimeOfDay = localizations.formatTimeOfDay(timeOfDay);

    setState(() => _timeController.text = formattedTimeOfDay);
  }

  Future<void> _saveEntry() async {
    if (_selectedMood.isEmpty || _dateController.text.trim().isEmpty ||
      _timeController.text.trim().isEmpty || _titleController.text.trim().isEmpty ||
      _bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill out all fields before saving."))
      );
      return;
    }

    final Map<String, String> entry = {
      "emoji": _selectedMood,
      "mood": _moods[_selectedMood] ?? "",
      "date": _dateController.text,
      "time": _timeController.text,
      "title": _titleController.text,
      "body": _bodyController.text,
      "id": DateTime.now().millisecondsSinceEpoch.toString()
    };

    await PreferencesService().addEntry(entry);

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Entry saved successfully!"))
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: TextButton(
              onPressed: _saveEntry, 
              child: Text("Save", style: TextStyle(fontSize: 19, color: Color.fromARGB(255, 66, 139, 223)))
            ),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        children: <Widget> [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              spacing: 10,
              children: <Widget> [
                SizedBox(height: 250),
                Text("How are you feeling?", style: TextStyle(fontSize: 23)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _moods.keys.map((emoji) {
                    return GestureDetector(
                      child: Opacity(
                        opacity: _selectedMood == emoji ? 1 : 0.5,
                        child: Text(emoji, style: TextStyle(fontSize: _selectedMood == emoji ? 50 : 40),
                        ),
                      ),
                      onTap: () => setState(() => _selectedMood = emoji)
                    );
                  }).toList(),
                ),
                if (_selectedMood.isNotEmpty) ...[
                  Text("${_moods[_selectedMood]}", style: TextStyle(fontSize: 23)),
                  SizedBox(height: 150),
                  TextButton(
                    onPressed: _nextPage, 
                    child: Text("V", style: TextStyle(fontSize: 20, color: Color.fromARGB(130, 0, 0, 0)))
                  )
                ]
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              spacing: 10,
              children: <Widget> [
                SizedBox(height: 220),
                Text("Select Date and Time", style: TextStyle(fontSize: 23)),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(labelText: "Date", floatingLabelBehavior: FloatingLabelBehavior.never, icon: Icon(Icons.date_range)),
                  onTap: _selectDate,
                ),
                TextField(
                  controller: _timeController,
                  readOnly: true,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(labelText: "Time", floatingLabelBehavior: FloatingLabelBehavior.never, icon: Icon(Icons.timelapse)),
                  onTap: _selectTime,
                ),
                if (_dateController.text.isNotEmpty && _timeController.text.isNotEmpty) ...[
                  SizedBox(height: 200),
                  TextButton(
                    onPressed: _nextPage, 
                    child: Text("V", style: TextStyle(fontSize: 20, color: Color.fromARGB(130, 0, 0, 0)))
                  )
                ]
              ],
            )
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:  Column(
              spacing: 30,
              children: <Widget> [
                SizedBox(height: 0),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "Title"
                  ),
                ),
                SizedBox(
                  height: 550,
                  child: TextField(
                    controller: _bodyController,
                    minLines: 23,
                    maxLines: null,
                    keyboardType: TextInputType.multiline
                  ),
                )
              ]
            )
          )

        ],
      )
    );
  }
}
