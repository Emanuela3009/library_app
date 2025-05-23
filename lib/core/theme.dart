import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // aggiunto per font personalizzati - Fredoka, Quicksand e Nunito

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light, // tema chiaro
    scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground, // sfondo soft iOS
    primaryColor: CupertinoColors.activeBlue, // colore tipico link iOS
    useMaterial3: true, // attiva lo stile più moderno (Material Design 3)

    // Definizione globale degli stili del testo
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.fredoka( // Titolo principale dell’app (es. Categories)
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: const Color.fromARGB(255, 106, 147, 221), 
      ),

      titleMedium: GoogleFonts.nunito( // Titoli di sezione come "Popular now"
        fontSize: 22,
        fontWeight: FontWeight.bold,  //grassetto
        color: const Color.fromARGB(255, 106, 147, 221), 
      ),

      bodyMedium: GoogleFonts.quicksand( // Testo per paragrafi, descrizioni
        fontSize: 17,
        color: const Color.fromARGB(221, 1, 30, 100),
      ),

      bodyLarge: GoogleFonts.quicksand( // Variante corpo più grande
        fontSize: 15,
        color: const Color.fromARGB(255, 39, 37, 176),
        fontWeight: FontWeight.bold,
      ),

      labelSmall: GoogleFonts.quicksand( // Variante testo in grassetto - utile per pulsanti
        fontSize: 15,
        fontWeight: FontWeight.bold,  
        color: const Color.fromARGB(221, 1, 30, 100),
      ),
    ),

    // Stile della AppBar (barra in alto)
    appBarTheme: AppBarTheme(
      color: CupertinoColors.systemGrey6,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.fredoka( // Titolo al centro in stile moderno
        fontWeight: FontWeight.w600,
        fontSize: 30, //titolo dell'app che compare in alto al centro in tutte le schermate 
        color: const Color.fromARGB(255, 30, 42, 120), 
      ),
      iconTheme: const IconThemeData(
        color:  const Color.fromARGB(255, 39, 37, 176), // colore delle icone in alto vicino al titolo
        size: 28 //icona più grande (di default tutto è a 24)
        ), 
    ),

    // Stile della BottomNavigationBar (barra di navigazione in basso)
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color.fromARGB(255, 30, 42, 120), // colore della barra è blu scuro
      selectedItemColor: CupertinoColors.white, // l’elemento selezionato è bianco
      unselectedItemColor: const Color.fromARGB(255, 143, 170, 220), // gli elementi non selezionati sono azzurri

      selectedLabelStyle: GoogleFonts.fredoka( // etichetta selezionata
        fontWeight: FontWeight.w600,
        color: CupertinoColors.white,
      ),
      unselectedLabelStyle: GoogleFonts.quicksand( // etichetta non selezionata
        fontWeight: FontWeight.w400,
        color: Color(0xFF8FAADC),
      ),
      elevation: 8,  //piccolo rialzo (effetto visivo, per dare profondità)
      type: BottomNavigationBarType.fixed, // voci fisse
    ),

    // Stile dei pulsanti elevati
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 106, 147, 221), // sfondo pulsante
        foregroundColor: Colors.white, // testo/icona del pulsante
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.fredoka( // stile testo pulsante
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}
