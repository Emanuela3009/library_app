import 'package:flutter/material.dart';

class AddBookPage extends StatelessWidget {
  const AddBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aggiungi libro")),
      body: const Center(child: Text("Qui puoi aggiungere un nuovo libro.")),
    );
  }
}