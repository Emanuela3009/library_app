import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryColor = Colors.black;
  static const _onPrimaryColor = Colors.white;
  static const _backgroundColor = Colors.white;
  static const _secondaryColor = Colors.grey;
  static const _errorColor = Colors.red;

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: _backgroundColor,
        primaryColor: _primaryColor,
        colorScheme: const ColorScheme.light(
          primary: _primaryColor,
          onPrimary: _onPrimaryColor,
          secondary: _secondaryColor,
          onSecondary: _primaryColor,
          background: _backgroundColor,
          surface: _backgroundColor,
          onBackground: _primaryColor,
          onSurface: _primaryColor,
          error: _errorColor,
          onError: _onPrimaryColor,
        ),
        textTheme: TextTheme(
          headlineLarge: _boldText(28),
          titleMedium: _boldText(20),
          bodyMedium: const TextStyle(fontSize: 16, color: Color(0xFF7C7C7C)),
          bodyLarge: _mediumText(15, Colors.black87),
          labelSmall: _mediumText(14),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: _primaryColor,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _backgroundColor,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: _primaryColor,
          ),
          iconTheme: IconThemeData(
            color: _primaryColor,
            size: 26,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 194, 194, 194),
          selectedItemColor: _primaryColor,
          unselectedItemColor: Color(0xFFBDBDBD),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
          elevation: 1,
          type: BottomNavigationBarType.fixed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: _onPrimaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      );

  static TextStyle _boldText(double size) => TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: _primaryColor,
      );

  static TextStyle _mediumText(double size, [Color color = _primaryColor]) =>
      TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color,
      );
}