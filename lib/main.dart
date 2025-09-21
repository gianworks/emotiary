import "package:flutter/material.dart";
import "package:emotiary/theme/app_theme.dart";
import "package:emotiary/screens/main_screen.dart";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Emotiary",
      theme: AppTheme.themeData,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false
    );
  }
}
