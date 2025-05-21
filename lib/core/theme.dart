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
      headlineLarge: GoogleFonts.fredoka( // Titolo principale dell’app (es. Home)
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),

      titleMedium: GoogleFonts.nunito( // Titoli di sezione come "Popular now"
        fontSize: 20,
        fontWeight: FontWeight.bold,  //grassetto
        color: Colors.black87,
      ),

      bodyMedium: GoogleFonts.quicksand( // Testo per paragrafi, descrizioni
        fontSize: 16,
        color: Colors.black87,
      ),

      bodyLarge: GoogleFonts.quicksand( // Variante corpo più grande
        fontSize: 15,
        color: Colors.black,
      ),
    ),

    // Stile della AppBar (barra in alto)
    appBarTheme: AppBarTheme(
      color: CupertinoColors.systemGrey6,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.fredoka( // Titolo al centro in stile moderno
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.black,
      ),
      iconTheme: const IconThemeData(color: Colors.black), // colore delle icone
    ),

    // Stile della BottomNavigationBar (barra di navigazione in basso)
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: CupertinoColors.systemGrey2, // sfondo grigio chiaro
      selectedItemColor: CupertinoColors.white, // colore dell’elemento selezionato
      unselectedItemColor: CupertinoColors.black, // colore degli altri elementi

      selectedLabelStyle: GoogleFonts.fredoka( // etichetta selezionata
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.quicksand( // etichetta non selezionata
        fontWeight: FontWeight.w400,
      ),
      elevation: 0,
      type: BottomNavigationBarType.fixed, // voci fisse
    ),

    // Stile dei pulsanti elevati
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // sfondo pulsante
        foregroundColor: Colors.white, // testo/icona
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
