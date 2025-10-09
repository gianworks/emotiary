import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/data/repositories/username_repository.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/core/helpers/dialog_helper.dart";
import "package:emotiary/core/helpers/snack_bar_helper.dart";
import "package:emotiary/widgets/primary_card.dart";

class SettingsScreen extends StatefulWidget {
  final Function(String) onSaveUsername;
  final Function() onDeleteAll;

  const SettingsScreen({
    super.key,
    required this.onSaveUsername,
    required this.onDeleteAll
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController(text: UsernameRepository.getUsername());

  void _showEditNameDialog() {
    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: "Enter a name..",
            border: OutlineInputBorder(),
          )
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, "Cancel"),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.isEmpty || _nameController.text.length > 10) return;

              widget.onSaveUsername(_nameController.text);
              Navigator.of(context).pop();
              SnackBarHelper.show("Name updated successfully.", context);
            },
            child: const Text("Save")
          )
        ]
      )
    );
  }

  void _showDeleteAllEntriesDialog() {
    DialogHelper.show(
      title: "Delete All Entries", 
      content: "Are you sure you want to delete all entries? This process cannot be undone.", 
      confirmText: "Delete All",
      onConfirm: () {
        widget.onDeleteAll();
        SnackBarHelper.show("All entries deleted successfully.", context);
      }, 
      context: context
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 32),
        Text("Settings", style: AppTextStyles.headlineLarge),
        const SizedBox(height: 32),
        PrimaryCard(
          padding: const EdgeInsets.all(16),
          content: Column(
            spacing: 8,
            children: [
              SizedBox(
                height: 48,
                child: ListTile(
                  title: const Text("Edit Name", style: TextStyle(fontSize: 16, color: AppColors.taupeGray, fontWeight: FontWeight.w500)),
                  trailing: const Icon(AntDesign.right_outline, size: 16, color: AppColors.taupeGray),
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  selectedTileColor: Colors.transparent,
                  tileColor: Colors.transparent,
                  onTap: _showEditNameDialog
                )
              ),
              SizedBox(
                height: 48,
                child: ListTile(
                  title: const Text("Delete All Entries", style: TextStyle(fontSize: 16, color: AppColors.taupeGray, fontWeight: FontWeight.w500)),
                  trailing: const Icon(AntDesign.right_outline, size: 16, color: AppColors.taupeGray),
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  selectedTileColor: Colors.transparent,
                  tileColor: Colors.transparent,
                  onTap: _showDeleteAllEntriesDialog
                )
              )
            ]
          )
        )
      ]
    );
  }
}
