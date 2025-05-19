/*import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
      type: BottomNavigationBarType.fixed, // fissa tutte le icone
      backgroundColor: Colors.grey,
      selectedItemColor: Colors.white,    // colore dell'icona selezionata
      unselectedItemColor: Colors.black,    // colore delle altre icone
      selectedFontSize: 12,
      unselectedFontSize: 12,
      iconSize: 26,
      showUnselectedLabels: true,
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
}*/
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      backgroundColor: Colors.grey,
      activeColor: Colors.white,
      color: Colors.black,
      style: TabStyle.react, // oppure .fixed, .textIn, .flip
      curveSize: 80,
      top: -20, // posizione leggermente più in alto
      items: const [
        TabItem(icon: Icons.search, title: 'Search'),
        TabItem(icon: Icons.folder_open, title: 'Categories'),
        TabItem(icon: Icons.home, title: 'Home'),
        TabItem(icon: Icons.bookmark, title: 'Library'),
        TabItem(icon: Icons.bar_chart, title: 'Activity'),
      ],
      initialActiveIndex: currentIndex,
      onTap: onTap,
    );
  }
}
