// ✅ FILE: main.dart (con reset opzionale del database e messaggio di conferma)
import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/Home_page.dart';
import 'data/database_helper.dart';
import 'data/fake_books.dart';
import 'data/fake_categories.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
