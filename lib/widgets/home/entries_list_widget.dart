import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_quill/flutter_quill.dart";
import "package:emotiary/models/entry.dart";
import "package:emotiary/theme/app_colors.dart";

class EntriesListWidget extends StatelessWidget {
  final List<Entry> entries;

  const EntriesListWidget({ super.key, required this.entries });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: entries.length,
          itemBuilder: (_, int index) {
            final int reverseIndex = entries.length - 1 - index;
            final Entry entry = entries[reverseIndex];

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

            return Card(
              margin: EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: AppColors.tan),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.moodEmoji, style: TextStyle(fontSize: 32)),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.mood, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.sienna)),
                              Text(entry.date, style: TextStyle(fontSize: 14, color: AppColors.brown))
                            ]
                          )
                        ]
                      ),
                      const SizedBox(height: 10),
                      IgnorePointer(
                        child: QuillEditor.basic(
                          controller: titleQuillController,
                          config: QuillEditorConfig(
                            scrollable: false,
                            expands: false,
                            showCursor: false,
                            customStyles: DefaultStyles(
                              paragraph: DefaultTextBlockStyle(
                                TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.veryDarkBrown),
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
                      IgnorePointer(
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
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: entry.activities.entries.map((MapEntry<String, String> mapEntry) {
                          final String activity = mapEntry.key;
                          final String activityEmoji = mapEntry.value;

                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
                            height: 25,
                            decoration: BoxDecoration(
                              color: AppColors.sand,
                              borderRadius: BorderRadius.circular(16)
                            ),
                            child: Text("$activityEmoji $activity", style: TextStyle(fontSize: 14, color: AppColors.saddleBrown))
                          );
                        }).toList(),
                      )
                    ]
                  )
                )
              )
            );
          }
        )
      ]
    );
  }
}
