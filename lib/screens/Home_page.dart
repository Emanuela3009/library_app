import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'addbook.dart';
import 'home_screen.dart';
import 'categories_page.dart';
import 'library_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2; // Start da 'Home'

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text('Search'));
      case 1:
        return CategoriesPage();
      case 2:
        return HomeScreen();
      case 3:
        return const LibraryPage();
      case 4:
        return const Center(child: Text('Activity'));
      default:
        return const HomeScreen();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Library"),
        leading: IconButton(
          // allinea il pulsante in alto a sinistra
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddBookPage()),
            ).then((_) {
              setState(() {}); // forza aggiornamento della Home al ritorno
            });
          },
        ),
      ),
      body: _getScreen(_currentIndex),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
