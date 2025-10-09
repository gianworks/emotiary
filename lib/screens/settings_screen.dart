import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/core/helpers/dialog_helper.dart";
import "package:emotiary/core/helpers/snack_bar_helper.dart";
import "package:emotiary/widgets/primary_card.dart";

class SettingsScreen extends StatefulWidget {
  final Function() onDeleteAll;

  const SettingsScreen({
    super.key,
    required this.onDeleteAll
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                  onTap: () {},
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
                  onTap: _showDeleteAllEntriesDialog,
                )
              ),
            ]
          )
        )
      ]
    );
  }
}
