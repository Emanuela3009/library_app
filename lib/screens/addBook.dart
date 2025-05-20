
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/fake_books.dart'; // contiene userBooks

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();   // serve per validare il form quando si preme “Add book”.

  // Controller per i campi , Servono per leggere il contenuto dei campi quando si preme il bottone.
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final plotController = TextEditingController();

  // Dropdown, valori di default dei menu a tendina 
  String selectedGenre = 'Fantasy';
  String selectedState = 'To Read';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Book")),
      body: 
        Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(   //per rendere scrollabile il form su dispositivi piccoli 
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),

              const SizedBox(height: 12),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),

              const SizedBox(height: 12),
              TextFormField(
                controller: plotController,
                decoration: const InputDecoration(labelText: 'Plot'),
                maxLines: 3,  
              ),

              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: selectedGenre,
                decoration: const InputDecoration(labelText: 'Genre'),
                items: ['Fantasy', 'Romance', 'Adventure', 'Sci-Fi', 'Horror']
                    .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
                    .toList(),
                onChanged: (value) => setState(() => selectedGenre = value!),
              ),

              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: selectedState,
                decoration: const InputDecoration(labelText: 'State'),
                items: ['To Read', 'Reading', 'Completed']
                    .map((state) => DropdownMenuItem(value: state, child: Text(state)))
                    .toList(),
                onChanged: (value) => setState(() => selectedState = value!),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newBook = Book(
                      title: titleController.text,
                      author: authorController.text,
                      genre: selectedGenre,
                      plot: plotController.text,
                      state: selectedState,
                      imagePath: 'assets/books/placeholder.jpg', // immagine fittizia
                    );

                    userBooks.add(newBook); // Aggiunta a lista finta

                    Navigator.pop(context); // Torna alla home
                  }
                },
                child: const Text("Add Book"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}