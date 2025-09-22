import 'package:flutter/material.dart';

class SnackBarHelper {
  static void show(BuildContext context, String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.grey[700],
          behavior: SnackBarBehavior.floating,
          content: Text(label, style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500))
        )
      );
  }
}
