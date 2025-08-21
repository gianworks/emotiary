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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("New Entry", style: TextStyle(fontWeight: FontWeight.w600)),
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
                SizedBox(height: 200),
                Text("Select date and time", style: TextStyle(fontSize: 23)),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(labelText: "Date", icon: Icon(Icons.date_range)),
                  onTap: _selectDate,
                ),
                TextField(
                  controller: _timeController,
                  readOnly: true,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(labelText: "Time", icon: Icon(Icons.timelapse)),
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
                  height: 600,
                  child: Expanded(
                    child: TextField(
                      controller: _bodyController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "What have you been up to?"
                      )
                    ),
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
