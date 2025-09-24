import "package:flutter/material.dart";
import "package:flutter_quill/flutter_quill.dart";
import "package:emotiary/core/config/hive_config.dart";
import "package:emotiary/core/theme/app_theme.dart";
import "package:emotiary/screens/main_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Emotiary",
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [ FlutterQuillLocalizations.delegate ],
      home: const MainScreen()
    );
  }
}
