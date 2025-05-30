import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import '../widgets/book_grid_card.dart';
import 'book_detail_page.dart';

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
      favoriteBooks = books
          .where((book) => book.isFavorite)
          .toList()
        ..sort((a, b) {
          final regex = RegExp(r'^\d+');
          final aMatch = regex.stringMatch(a.title);
          final bMatch = regex.stringMatch(b.title);

          if (aMatch != null && bMatch != null) {
            return int.parse(aMatch).compareTo(int.parse(bMatch));
          } else if (aMatch != null) {
            return -1;
          } else if (bMatch != null) {
            return 1;
          } else {
            return a.title.toLowerCase().compareTo(b.title.toLowerCase());
          }
        });
    });
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screen = MediaQuery.of(context).size;
    final crossAxisCount = _getCrossAxisCount(screen.width);
    final padding = screenWidth * 0.04;

    return Scaffold(
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
                      _loadFavorites(); 
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