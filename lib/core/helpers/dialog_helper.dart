import "package:flutter/material.dart";

class DialogHelper {
  static Future<void> show({
    required String title, 
    required String content, 
    required String confirmText, 
    required Function onConfirm, 
    required BuildContext context
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, "Cancel"),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
