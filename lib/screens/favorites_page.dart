import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import '../widgets/book_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Book> favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final books = await DatabaseHelper.instance.getAllBooks();
    setState(() {
      favoriteBooks = books.where((book) => book.isFavorite).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Favorites")),
      body:
          favoriteBooks.isEmpty
              ? const Center(child: Text("No favorites yet"))
              : ListView.builder(
                itemCount: favoriteBooks.length,
                itemBuilder: (context, index) {
                  final book = favoriteBooks[index];
                  return BookCard(book: book, onUpdate: _loadFavorites);
                },
              ),
    );
  }
}
