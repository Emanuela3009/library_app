import 'book_detail_page.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import '../widgets/book_grid_card.dart';




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
      appBar: AppBar(title: const Text("Your Favorites")),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: favoriteBooks.isEmpty
            ? const Center(child: Text("No favorites yet"))
            : GridView.builder(
                itemCount: favoriteBooks.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: padding,
                  crossAxisSpacing: padding,
                  childAspectRatio: 3 / 4.5,
                ),
                itemBuilder: (context, index) {
                  final book = favoriteBooks[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailPage(book: book),
                        ),
                      );
                      _loadFavorites(); // aggiorna lista al ritorno
                    },
                    child: BookGridCard(
                      book: book,
                      onFavoriteToggle: _loadFavorites,
                    ),
                  );
                },
              ),
      ),
    );
  }
}