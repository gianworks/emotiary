import 'package:flutter/material.dart';

class SnackBarHelper {
  static void show(String label, BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(milliseconds: 2500),
          backgroundColor: Colors.grey[700],
          behavior: SnackBarBehavior.floating,
          content: Text(label, style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500))
        )
      );
  }
}
