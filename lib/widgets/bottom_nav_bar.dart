import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final shortestSide = screen.shortestSide;
    final isTablet = shortestSide >= 600;
    final isLandscape = screen.width > screen.height;

    // Imposta dimensioni dinamiche
    final double iconSize = isTablet
        ? 30
        : isLandscape
            ? 22
            : 26;

    final double fontSize = isTablet
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
