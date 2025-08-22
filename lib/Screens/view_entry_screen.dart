import 'package:flutter/material.dart';

class ViewEntryScreen extends StatelessWidget {

  final Map _entry;

  const ViewEntryScreen({super.key, required Map entry}) : _entry = entry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Text("View Entry", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        children: [
          Text("${_entry["date"]}", style: TextStyle(fontSize: 18)),
          Text("${_entry["time"]}", style: TextStyle(fontSize: 18)),
          SizedBox(height: 15),
          Center(child: Text("${_entry["emoji"]}", style: TextStyle(fontSize: 36))),
          Center(child: Text("Feeling ${_entry["mood"]}", style: TextStyle(fontSize: 16))),
          SizedBox(height: 15),
          Text("${_entry["title"]}", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          Text("${_entry["body"]}", style: TextStyle(fontSize: 18)),
        ],
      )
    );
  }

}
