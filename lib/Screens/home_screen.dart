import 'package:emotiary/Screens/view_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:emotiary/Screens/new_entry_screen.dart';
import 'package:emotiary/Services/preferences_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<dynamic> _entries = [];

  void _goToNewEntry() async {
    final bool result = await Navigator.push(
      context, MaterialPageRoute(builder: (_) => NewEntryScreen())
    );
    if (result == false) return;
    _updateEntries();
  }

  void _updateEntries() {
    setState(() => _entries = PreferencesService().getEntries());
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
      appBar: AppBar(
        title: Text("Home", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToNewEntry,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(Icons.add, color: Colors.white)
      ),
      body: ListView(
        children: [
          SizedBox(height: 50),
          
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
                        onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => ViewEntryScreen(entry: entry))
                        )
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
