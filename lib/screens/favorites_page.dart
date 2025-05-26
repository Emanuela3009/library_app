import 'dart:io';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
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
        padding:  EdgeInsets.all(padding),
        child: favoriteBooks.isEmpty
            ? const Center(child: Text("No favorites yet"))
            : GridView.builder(
                itemCount: favoriteBooks.length,
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
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
                      _loadFavorites(); // aggiorna al ritorno
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Center(
                               child: book.imagePath.startsWith('assets/')
                                  ? Image.asset(
                                      book.imagePath,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(book.imagePath),
                                      fit: BoxFit.cover,
                                    ),
                              ),
                                Positioned(
                                top: 6,
                                right: 6,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () async {
                                    book.isFavorite = false;
                                    await DatabaseHelper.instance.insertBook(book);
                                    setState(() => favoriteBooks.remove(book));
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.pink,
                                    size: screenWidth * 0.05,
                                  ),
                                ),
                              ),

                              ],
                            ),
                          ),
                           SizedBox(height: screenWidth * 0.02),
                          Text(
                            book.title,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            book.author,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '⭐ ${book.rating ?? 0}/5',
                            style:  TextStyle(
                              color: Colors.purple,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          Text(
                            book.userState ?? '',
                            style:  TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
