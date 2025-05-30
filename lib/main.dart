import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'data/database_helper.dart';
import 'data/fake_books.dart';
import 'data/fake_categories.dart';

import 'screens/splahscreen.dart';


void main() async {
 
  WidgetsFlutterBinding.ensureInitialized();
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