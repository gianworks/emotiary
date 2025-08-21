import 'package:flutter/material.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final PageController _pageController = PageController();
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
          Column(
            children: <Widget> [
              SizedBox(height: 250),
              Text("How are you feeling?", style: TextStyle(fontSize: 23)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
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
              ),
              if (_selectedMood.isNotEmpty) ...[
                Text("${_moods[_selectedMood]}", style: TextStyle(fontSize: 23)),
                SizedBox(height: 200),
                TextButton(
                  onPressed: _nextPage, 
                  child: Text("V", style: TextStyle(fontSize: 20, color: Color.fromARGB(130, 0, 0, 0)))
                )
              ]
            ],
          )
        ],
      )
    );
  }
}
