import 'package:flutter/material.dart';
import 'addbook.dart'; // importa la schermata di destinazione


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Vai alla seconda pagina"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddBookPage()),
            );
          },
        ),
      ),
    );
  }
}

