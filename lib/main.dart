import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/Home_page.dart';
import 'data/database_helper.dart';
import 'data/fake_books.dart';
import 'data/fake_categories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  await DatabaseHelper.instance.populateInitialBooks(popularBooks);
  await DatabaseHelper.instance.populateInitialCategories(fakeCategories);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const HomePage(),
    );
  }
}

