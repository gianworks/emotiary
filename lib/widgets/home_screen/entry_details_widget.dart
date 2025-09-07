import "dart:convert";
import "package:flutter/material.dart";
import 'package:sliding_up_panel/sliding_up_panel.dart';
import "package:flutter_quill/flutter_quill.dart";
import "package:emotiary/models/entry.dart";
import "package:emotiary/theme/app_colors.dart";

class EntryDetailsWidget extends StatelessWidget {
  final Entry entry;
  final PanelController panelController;

  final Function(Entry) onDeleteEntry;

  const EntryDetailsWidget({ super.key, required this.entry, required this.panelController, required this.onDeleteEntry });

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: Text("Delete Entry", style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.veryDarkBrown)),
        content: Text("Are you sure you want to delete this entry? This process cannot be undone.", style: TextStyle(color: AppColors.brown)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, "Cancel"),
            child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.sienna))
          ),
          TextButton(
            onPressed: () { 
              onDeleteEntry(entry);
              Navigator.pop(context, "Delete"); 
              panelController.close();
            },
            child: Text("Delete", style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.sienna))
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final QuillController titleQuillController = QuillController(
      readOnly: true,
      document: Document.fromJson(jsonDecode(entry.titleJson)),
      selection: TextSelection.collapsed(offset: 0)
    );

    final QuillController noteQuillController = QuillController(
      readOnly: true,
      document: Document.fromJson(jsonDecode(entry.noteJson)),
      selection: TextSelection.collapsed(offset: 0)
    );

    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 33,
            height: 5,
            margin: EdgeInsets.only(top: 12.5),
            decoration: BoxDecoration(color: AppColors.almond, borderRadius: BorderRadius.circular(12))
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.moodEmoji, style: TextStyle(fontSize: 40)),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.mood, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.sienna)),
                            Text(entry.date, style: TextStyle(fontSize: 16, color: AppColors.brown))
                          ]
                        )
                      ]
                    ),
                    const SizedBox(height: 20),
                    IgnorePointer(
                      child: QuillEditor.basic(
                        controller: titleQuillController,
                        config: QuillEditorConfig(
                          scrollable: false,
                          expands: false,
                          showCursor: false,
                          customStyles: DefaultStyles(
                            paragraph: DefaultTextBlockStyle(
                              TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.veryDarkBrown),
                              HorizontalSpacing(0, 0),
                              VerticalSpacing(0, 0),
                              VerticalSpacing(0, 0),
                              null
                            )
                          )
                        )
                      )
                    ),
                    const SizedBox(height: 10),
                    Container(
                      constraints: BoxConstraints(minHeight: 100),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.whiteSmoke, 
                        border: Border.all(color: AppColors.gainsboro), 
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: IgnorePointer(
                        child: QuillEditor.basic(
                          controller: noteQuillController,
                          config: QuillEditorConfig(
                            scrollable: false,
                            expands: false,
                            showCursor: false,
                            customStyles: DefaultStyles(
                              paragraph: DefaultTextBlockStyle(
                                TextStyle(fontSize: 16, color: AppColors.brown),
                                HorizontalSpacing(0, 0),
                                VerticalSpacing(0, 0),
                                VerticalSpacing(0, 0),
                                null
                              )
                            )
                          )
                        )
                      )
                    ),
                    const SizedBox(height: 20),
                    Text("Activities", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.veryDarkBrown)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: entry.activities.entries.map((MapEntry<String, String> mapEntry) {
                        final String activity = mapEntry.key;
                        final String activityEmoji = mapEntry.value;

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(16)),
                          child: Text("$activityEmoji $activity", style: TextStyle(fontSize: 14, color: AppColors.saddleBrown))
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10)
                  ]
                )
              )
            )
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.sienna,
                side: BorderSide(width: 1, color: AppColors.sienna),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5)
              ),
              icon: Icon(Icons.delete, size: 24),
              label: Text("Delete", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              onPressed: () => _showDeleteDialog(context)
            )
          ),
          const SizedBox(height: 60)
        ]
      )
    );
  }
}
