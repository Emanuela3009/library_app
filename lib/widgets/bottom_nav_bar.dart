import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  // Indice della pagina selezionata
  final int currentIndex;

  // Funzione da chiamare quando l'utente tocca un'icona
  final Function(int) onTap;

  // Costruttore con parametri obbligatori
  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // evidenzia la voce attuale
      onTap: onTap, // esegue la funzione passata quando clicchi su un'icona
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder_open),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Activity',
        ),
      ],
    );
  }
}