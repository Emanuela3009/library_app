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
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
    return SalomonBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.search),
          title: const Text("Search"),
          selectedColor: Colors.white,
          unselectedColor: Colors.black,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.folder_open),
          title: const Text("Categories"),
          selectedColor: Colors.white,
          unselectedColor: Colors.black,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
          selectedColor: Colors.white,
          unselectedColor: Colors.black,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.bookmark),
          title: const Text("Library"),
          selectedColor: Colors.white,
          unselectedColor: Colors.black,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.bar_chart),
          title: const Text("Activity"),
          selectedColor: Colors.white,
          unselectedColor: Colors.black,
        ),
      ],
    );
  }
}
