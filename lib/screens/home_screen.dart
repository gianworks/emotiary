import "package:flutter/material.dart";
import "package:emotiary/models/entry.dart";
import "package:emotiary/theme/app_colors.dart";
import "package:emotiary/widgets/home/entries_list_widget.dart";

class HomeScreen extends StatefulWidget {
  final List<Entry> entries;

  const HomeScreen({ super.key, required this.entries });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emotiary")),
      body: Stack(
        children: [
          ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 40),
              Text("Your Journal Entries", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.veryDarkBrown)),
              const SizedBox(height: 20),
              if (widget.entries.isNotEmpty) ...[
                EntriesListWidget(entries: widget.entries)
              ]
              else ...[
                const SizedBox(height: 30),
                Text("You have no entries yet..", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.brown)),
                const SizedBox(height: 5),
                Text("Tap the write button to create an entry!", style: TextStyle(fontSize: 16, color: AppColors.brown))
              ]
            ]
          )
        ]
      )
    );
  }
}
