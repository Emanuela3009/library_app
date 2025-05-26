// ✅ FILE: main.dart (con reset opzionale del database e messaggio di conferma)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // <--- aggiunto import
import 'core/theme.dart';
import 'screens/Home_page.dart';
import 'data/database_helper.dart';
import 'data/fake_books.dart';
import 'data/fake_categories.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'screens/splahscreen.dart';

Future<void> printFilesInDocuments() async {
  final dir = await getApplicationDocumentsDirectory();
  final files = dir.listSync();
  print('Files in Documents:');
  for (var file in files) {
    print(file.path);
  }
}

void main() async {
  print("App started");
  WidgetsFlutterBinding.ensureInitialized();

  // Stampo i file nella directory Documents per debug
  await printFilesInDocuments();

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'library_app.db');

  // ✅ Cancella il database SOLO se si avvia con: flutter run --dart-define=RESET_DB=true
  if (bool.hasEnvironment("RESET_DB") &&
      const bool.fromEnvironment("RESET_DB")) {
    await deleteDatabase(path);
    print("📦 Database reset completato! Nuovo schema con isUserBook applicato.");
  }

  await DatabaseHelper.instance.database;
  await DatabaseHelper.instance.populateInitialBooks(popularBooks);
  await DatabaseHelper.instance.populateInitialCategories(fakeCategories);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme.copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      home:  SplashPage(),
    );
  }
}