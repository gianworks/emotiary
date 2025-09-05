import "package:flutter/material.dart";
import 'package:sliding_up_panel/sliding_up_panel.dart';
import "package:emotiary/models/entry.dart";
import "package:emotiary/theme/app_colors.dart";
import "package:emotiary/widgets/home/entries_list_widget.dart";
import "package:emotiary/widgets/home/entry_details_widget.dart";

class HomeScreen extends StatefulWidget {    
  final List<Entry> entries;
  final PanelController panelController;

  final Function(Widget) onOpenPanel;

  const HomeScreen({ super.key, required this.entries, required this.panelController, required this.onOpenPanel });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onSelectEntry(Entry entry) {
    widget.panelController.animatePanelToPosition(1, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    widget.onOpenPanel(EntryDetailsWidget(entry: entry, panelController: widget.panelController));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emotiary"), forceMaterialTransparency: true),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 50),
          Text("Your Journal Entries", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.veryDarkBrown)),
          const SizedBox(height: 20),
          if (widget.entries.isNotEmpty) ...[
            EntriesListWidget(entries: widget.entries, onSelectEntry: _onSelectEntry)
          ]
          else ...[
            Text("You have no entries yet.\nTap the write button to create a new entry!", style: TextStyle(fontSize: 16, color: AppColors.brown))
          ]
        ]
      )
    );
  }
}
