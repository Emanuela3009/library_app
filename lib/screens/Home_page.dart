import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/appbar_icon_button.dart';
import 'addbook.dart';
import 'home_screen.dart'; 
import 'categories_page.dart';


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
     return const Center(child: Text('Categories'));
    case 1:
      return CategoriesPage();
    case 2:
      return HomeScreen(); // ← qui viene sempre ricreato!
    case 3:
      return const Center(child: Text('Search'));
    case 4:
      return const Center(child: Text('Library'));
    case 5:
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

      // Leading: pulsante in alto a sinistra con effetto splash al tap
      leading: InkWell(
        // Effetto cerchio sul tocco
        borderRadius: BorderRadius.circular(100),

        // Quando premo sull'icona, diventa azzurra -> effetto splash
        splashColor: const Color.fromARGB(255, 106, 147, 221),

        // Azione da eseguire al tap
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookPage()),
          ).then((_) {
            setState(() {}); // aggiorna la Home al ritorno
          });
        },

        // Quando clicco sull'icona esce un cerchio attorno che la evidenzia 
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.add,  //icona in alto a sinistra
            // il colore e la dimensione vengono presi dal Theme.appBarTheme.iconTheme
          ),
        ),
      ),
    ),

    // Corpo della pagina: cambia contenuto in base all’indice selezionato
    body: _getScreen(_currentIndex),

    // Barra di navigazione in basso (personalizzata)
    bottomNavigationBar: BottomNavBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
    ),
  );
}

}
