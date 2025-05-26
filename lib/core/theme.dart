import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    scaffoldBackgroundColor: Colors.white, // Bianco puro
    primaryColor: Colors.black, // Nero per testi importanti

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black, // Titolo principale (es. "Home")
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black, // Titoli sezioni tipo "Libri gratuiti"
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Color(0xFF7C7C7C), // Sottotitoli grigi chiari
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Colors.black,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
        size: 26,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 194, 194, 194),
      selectedItemColor: Colors.black, // Attivo: nero
      unselectedItemColor: Color(0xFFBDBDBD), // Non attivo: grigio chiaro
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w400,
      ),
      elevation: 1,
      type: BottomNavigationBarType.fixed,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // Pulsante nero
        foregroundColor: Colors.white,
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
}
