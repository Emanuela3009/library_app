import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/* Widget personalizzato per la BottomNavigationBar.
   Mostra 5 icone con label: Search, Categories, Home, Favorites, Activity.
   Supporta adattamento responsive per tablet e landscape. */
class BottomNavBar extends StatelessWidget {
  final int currentIndex; // Indice attualmente selezionato
  final Function(int) onTap; // Callback al tap su un item

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /* Costruisce la bottom navigation con icone e label personalizzati.
     Adatta dimensioni in base al tipo di dispositivo e orientamento. */
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final shortestSide = screen.shortestSide;
    final isTablet = shortestSide >= 600;
    final isLandscape = screen.width > screen.height;

    // Dimensioni dinamiche per icone e testo
    final double iconSize =
        isTablet
            ? 30
            : isLandscape
            ? 22
            : 26;

    final double fontSize =
        isTablet
            ? 14
            : isLandscape
            ? 11
            : 12;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey.shade500,
      selectedFontSize: fontSize,
      unselectedFontSize: fontSize,
      iconSize: iconSize,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          activeIcon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.collections),
          activeIcon: Icon(CupertinoIcons.collections_solid),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.house_fill),
          activeIcon: Icon(CupertinoIcons.house_fill),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.heart),
          activeIcon: Icon(CupertinoIcons.heart_fill),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          activeIcon: Icon(Icons.bar_chart),
          label: 'Activity',
        ),
      ],
    );
  }
}
