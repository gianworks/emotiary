import 'package:flutter/material.dart';
import 'package:emotiary/Services/preferences_service.dart';

class ViewEntryScreen extends StatefulWidget {
  
  final Map _entry;

  const ViewEntryScreen({super.key, required Map entry}) : _entry = entry;

  @override
  State<ViewEntryScreen> createState() => _ViewEntryScreenState();
}

class _ViewEntryScreenState extends State<ViewEntryScreen> {

  void _deleteEntry() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Delete Entry"),
        content: Text("Are you sure you want to delete this entry? This process cannot be undone."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, "Cancel");
            },
            child: Text("Cancel")
          ),
          TextButton(
            onPressed: () {
              PreferencesService().deleteEntry(widget._entry);
              Navigator.pop(context, "Delete");
              Navigator.pop(context, true);
            },
            child: Text("Delete")
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Text("View Entry", style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: TextButton(
              onPressed: _deleteEntry, 
              child: Text("Delete", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 223, 66, 66)))
            ),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        children: [
          Text("${widget._entry["date"]}", style: TextStyle(fontSize: 16)),
          Text("${widget._entry["time"]}", style: TextStyle(fontSize: 16)),
          SizedBox(height: 15),
          Center(child: Text("${widget._entry["emoji"]}", style: TextStyle(fontSize: 36))),
          Center(child: Text("Feeling ${widget._entry["mood"]}", style: TextStyle(fontSize: 18))),
          SizedBox(height: 15),
          Text("${widget._entry["title"]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          Text("${widget._entry["body"]}", style: TextStyle(fontSize: 16)),
        ],
      )
    );
  }

}
