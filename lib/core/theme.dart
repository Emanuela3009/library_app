/*import 'package:flutter/material.dart';


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
); */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground, // sfondo soft iOS
    fontFamily: 'Times New Roman',
    primaryColor: CupertinoColors.activeBlue, // colore tipico link iOS
    useMaterial3: true, // attiva lo stile più moderno
    
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 16),
    ),
    
    appBarTheme: const AppBarTheme(
      color: CupertinoColors.systemGrey6,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Times New Roman',
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: CupertinoColors.systemGrey2,
      selectedItemColor: CupertinoColors.white,
      unselectedItemColor: CupertinoColors.black,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Times New Roman',
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Times New Roman',
        fontWeight: FontWeight.w400,
      ),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
