import 'package:flutter/material.dart';


final ThemeData myAppTheme = ThemeData(
  useMaterial3: true, // se vuoi usare Material Design 3
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.black,
    elevation: 2,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 11, 24, 109),
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.indigo,
    unselectedItemColor: Colors.grey,
    backgroundColor: Colors.black,
    elevation: 8,
  ),
); 