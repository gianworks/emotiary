import 'package:flutter/material.dart';
import 'package:emotiary/Screens/new_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _goToNewEntry() {
    Navigator.push(
      context, MaterialPageRoute(
        builder: (_) => NewEntryScreen()
      )
    );
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
      )
    );
  }
}
