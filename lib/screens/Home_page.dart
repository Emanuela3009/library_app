import 'package:flutter/material.dart';
import 'package:library_app/screens/favorites_page.dart';
import '../widgets/bottom_nav_bar.dart';
import 'addbook.dart';
import 'home_screen.dart';
import 'categories_page.dart';
import 'search_page.dart';
import 'myactivity_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}


class HomePageState extends State<HomePage> {
  int _currentIndex = 2;
  int _homeScreenKey = 0;

  final List<String> _titles = [
  'Search Books',
  'Categories',
  'Book Library',
  'Your Favorites',
  'Activity',
];

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const SearchPage();
      case 1:
        return const CategoriesPage();
      case 2:
        return HomeScreen(key: ValueKey(_homeScreenKey), onTabChanged: setIndex);
      case 3:
        return const FavoritesPage();
      case 4:
        return const MyActivityPage();
      default:
        return HomeScreen(onTabChanged: setIndex);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Serve a home_screen.dart per navigare!
  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isLandscape = mq.orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: (_currentIndex == 2)
            ? InkWell(
                  borderRadius: BorderRadius.circular(100),
                  splashColor: const Color.fromARGB(255, 0, 0, 0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddBookPage(),
                      ),
                    ).then((_) {
                      setState(() {
                        _homeScreenKey++;
                        _currentIndex = 2;
                      });
                    });
                  },
                  child:  Padding(
                    padding: EdgeInsets.all(isLandscape ? 6 : 10),
                    child: Icon(Icons.add,
                            size: isLandscape ? 28 : 24,),
                    
                  ),
                )
                : null,
      ),
      body: _getScreen(_currentIndex),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
