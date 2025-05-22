// ✅ FILE: main.dart
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
  //await deleteDatabase(path); // ← Rimuovi questa riga dopo il primo avvio

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
