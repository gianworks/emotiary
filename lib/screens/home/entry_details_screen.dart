import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:flutter_quill/flutter_quill.dart";
import "package:emotiary/data/models/entry.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/core/utils/quill_utils.dart";
import "package:emotiary/core/helpers/dialog_helper.dart";
import "package:emotiary/core/helpers/text_block_style_helper.dart";
import "package:emotiary/core/helpers/snack_bar_helper.dart";

class EntryDetailsScreen extends StatelessWidget {
  final Entry entry;
  final Function(Entry entry) onDeleteEntry;
  final Function(Entry entry) onEditEntry;

  const EntryDetailsScreen({
    super.key,
    required this.entry,
    required this.onDeleteEntry,
    required this.onEditEntry
  });

  void _showDeleteDialog(BuildContext context) {
    DialogHelper.show(
      title: "Delete Entry", 
      content: "Are you sure you want to delete this entry? This process cannot be undone.", 
      confirmText: "Delete", 
      onConfirm: () {
        onDeleteEntry(entry);
        Navigator.of(context).pop();
        SnackBarHelper.show("Entry deleted successfully.", context);
      }, 
      context: context
    );
  }

  @override
  Widget build(BuildContext context) {
    final QuillController titleController = QuillController(
      readOnly: true,
      document: QuillUtils.jsonToDocument(entry.titleJson),
      selection: TextSelection.collapsed(offset: 0)
    );

   final QuillController textController = QuillController(
      readOnly: true,
      document: QuillUtils.jsonToDocument(entry.textJson),
      selection: TextSelection.collapsed(offset: 0)
    );

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: Padding(
          padding: const EdgeInsetsGeometry.only(left: 16),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(AntDesign.left_outline, color: AppColors.darkBrown),
          )
        ),
        centerTitle: true,
        title: Text(entry.date, style: const TextStyle(fontSize: 16, color: AppColors.darkBrown, fontWeight: FontWeight.w500)),
        actions: [
          Padding(
            padding: const EdgeInsetsGeometry.only(right: 16),
            child: Row(
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onEditEntry(entry);
                    },
                    icon: const Icon(AntDesign.edit_outline, color: AppColors.darkBrown)
                  )
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 52,
                  height: 52,
                  child: IconButton(
                    onPressed: () => _showDeleteDialog(context),
                    icon: const Icon(AntDesign.delete_outline, color: AppColors.darkBrown)
                  )
                ),
              ]
            )
          )
        ]
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 48),
          Row(
            children: [
              Text(entry.moodEmoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 8),
              Text(entry.mood, style: const TextStyle(fontSize: 16, color: AppColors.darkBrown, fontWeight: FontWeight.w500))
            ]
          ),
          const SizedBox(height: 8),
          QuillEditor.basic(
            controller: titleController,
            config: QuillEditorConfig(
              showCursor: false,
              customStyles: DefaultStyles(paragraph: TextBlockStyleHelper.create(AppTextStyles.headlineMedium))
            )
          ),
          const SizedBox(height: 16),
          QuillEditor.basic(
            controller: textController,
            config: QuillEditorConfig(
              showCursor: false,
              customStyles: DefaultStyles(paragraph: TextBlockStyleHelper.create(AppTextStyles.bodyLarge))
            )
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: entry.activities.entries.map(
              (activity) => Text("${activity.value} ${activity.key.toLowerCase()}", style: AppTextStyles.bodyLarge)
            ).toList()
          ),
          const SizedBox(height: 64),
        ]
      )
    );
  }
}