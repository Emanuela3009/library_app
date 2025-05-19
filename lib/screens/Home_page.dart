import 'package:flutter/material.dart';
import 'addbook.dart'; // importa la schermata di destinazione


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page"),
              leading: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                MaterialPageRoute(builder: (context) => const AddBookPage()),
            );
          },
        )),
       
      
    );
  }
}

