import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'addbook.dart';
import 'home_screen.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2; // Start da 'Home'

  final List<Widget> _screens = [
    Center(child: Text('Search')),
    Center(child: Text('Categories')),
    const HomeScreen(),
    Center(child: Text('Library')),
    Center(child: Text('Activity')),
  ];

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
        leading: IconButton(      // allinea il pulsante in alto a sinistra
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddBookPage()),
            );
          },
        ),
      ),
      body:  _screens[_currentIndex],

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
