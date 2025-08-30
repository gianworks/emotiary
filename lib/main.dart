import "package:flutter/material.dart";
import "package:emotiary/screens/main_screen.dart";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Emotiary",
      debugShowCheckedModeBanner: false,
      home: MainScreen()
    );
  }
}
