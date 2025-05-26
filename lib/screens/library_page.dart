import 'dart:io';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import '../widgets/book_grid_card.dart'; // Importa il widget riutilizzabile
import 'book_detail_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Book> allBooks = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final all = await DatabaseHelper.instance.getAllBooks();
    final books = all.where((b) => b.isUserBook).toList(); // Solo libri aggiunti manualmente
    setState(() {
      allBooks = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Numero colonne dinamico in base alla larghezza, minimo 2 colonne
    int crossAxisCount = 2;
    if (screenWidth >= 1200) {
      crossAxisCount = 5;
    } else if (screenWidth >= 900) {
      crossAxisCount = 4;
    } else if (screenWidth >= 600) {
      crossAxisCount = 3;
    }

    final padding = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(title: const Text("Library")),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: allBooks.isEmpty
            ? const Center(child: Text("No books added yet"))
            : GridView.builder(
                itemCount: allBooks.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: padding,
                  crossAxisSpacing: padding,
                  childAspectRatio: 3 / 4.5,
                ),
                itemBuilder: (context, index) {
                  final book = allBooks[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailPage(book: book),
                        ),
                      );
                      _loadBooks(); // aggiorna lista al ritorno
                    },
                    child: BookGridCard(
                      book: book,
                      onFavoriteToggle: _loadBooks,
                    ),
                  );
                },
              ),
      ),
    );
  }
}