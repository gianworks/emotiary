import "package:flutter/material.dart";
import "package:flutter_quill/flutter_quill.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:emotiary/boxes/entry_box.dart";
import "package:emotiary/theme/app_theme.dart";
import "package:emotiary/screens/main_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await EntryBox.initEntriesBox();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Emotiary",
      theme: AppTheme.appThemeData,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [ FlutterQuillLocalizations.delegate ],
      home: MainScreen()
    );
  }
}
