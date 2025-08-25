import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:emotiary/Services/preferences_service.dart';

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

  late String _selectedMood = "";  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setDateControllerText(DateTime.now());
    _setTimeControllerText(TimeOfDay.now());
  }

  void _setDateControllerText(DateTime dateTime) => setState(() => _dateController.text = DateFormat("dd/MM/yyyy").format(dateTime));
  void _setTimeControllerText(TimeOfDay timeOfDay) => setState(() => _timeController.text = timeOfDay.format(context));

  Future<void> _selectDate() async {
    DateTime? dateTime = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );

    if (dateTime == null || !mounted) return;

    _setDateControllerText(dateTime);
  }

  Future<void> _selectTime() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now()
    );

    if (timeOfDay == null || !mounted) return;

    _setTimeControllerText(timeOfDay);
  }

  Future<void> _saveEntry() async {
    if (_selectedMood.isEmpty || _dateController.text.trim().isEmpty || _timeController.text.trim().isEmpty 
      || _titleController.text.trim().isEmpty || _bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields before saving.")));
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Entry saved successfully!")));

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: TextField(
          controller: _titleController,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: "Title"
          )
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _saveEntry, 
              child: Text("Done", style: TextStyle(fontSize: 20))
            )
          )
        ]
      ),
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Column(
            children: <Widget> [
              const SizedBox(height: 150),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 140,
                    height: 60,
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(icon: Icon(Icons.date_range)),
                      onTap: _selectDate,
                    )
                  ),
                  SizedBox(
                    width: 120,
                    height: 60,
                    child: TextField(
                      controller: _timeController,
                      readOnly: true,
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(icon: Icon(Icons.access_time)),
                      onTap: _selectTime,
                    )
                  )
                ]
              ),
              const SizedBox(height: 50),
              Text("How are you feeling?", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _moods.keys.map((String emoji) {
                  final bool isEmojiSelected = (_selectedMood == emoji);
                  return GestureDetector(
                    child: Opacity(
                      opacity: isEmojiSelected ? 1 : 0.5,
                      child: Column(
                        children: <Widget>[
                          Text(emoji, style: TextStyle(fontSize: isEmojiSelected ? 50 : 40)),
                          Text(_moods[emoji] ?? "", style: TextStyle(fontSize: isEmojiSelected ? 20 : 15))
                        ]
                      )
                    ),
                    onTap: () => setState(() => _selectedMood = emoji)
                  );
                }).toList(),
              ),
              if (_selectedMood.isNotEmpty) ...[
                const SizedBox(height: 200),
                IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.keyboard_double_arrow_down),
                  onPressed: () => _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut)
                )
              ]
            ]
          ),
          Column(
            children: <Widget>[
              const SizedBox(height: 50),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 650,
                color: Colors.white,
                child: TextField(
                  controller: _bodyController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "What have you been up to?"
                  )
                )
              )
            ]
          )
        ]
      )
    );
  }
}
