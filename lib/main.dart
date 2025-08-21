import 'package:flutter/material.dart';
import 'package:emotiary/Screens/home_screen.dart';
import 'package:emotiary/Services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Emotiary",
      home: HomeScreen(),
    );
  }
}
