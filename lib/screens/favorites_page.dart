import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import '../widgets/book_grid_card.dart';
import 'book_detail_page.dart';

// Schermata che mostra tutti i libri contrassegnati come "preferiti"
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
    _loadFavorites(); // Carica i preferiti al primo avvio della schermata
  }

  // Recupera tutti i libri dal database e filtra quelli contrassegnati come preferiti
  Future<void> _loadFavorites() async {
    final books = await DatabaseHelper.instance.getAllBooks();
    setState(() {
      favoriteBooks = books
          .where((book) => book.isFavorite) // tiene solo i preferiti
          .toList()
        ..sort((a, b) {
          // Ordina i libri in base al numero iniziale del titolo, se presente
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.04;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: favoriteBooks.isEmpty
            // Messaggio se non ci sono libri preferiti
            ? const Center(child: Text("No favorites yet"))
            // Visualizzazione a griglia dei libri preferiti
            : GridView.builder(
                itemCount: favoriteBooks.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: padding,
                  crossAxisSpacing: padding,
                  childAspectRatio: 3 / 4.5,
                ),
                itemBuilder: (context, index) {
                  final book = favoriteBooks[index];
                  return GestureDetector(
                    // Quando si clicca su un libro preferito, si apre la pagina di dettaglio
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailPage(book: book),
                        ),
                      );
                      _loadFavorites(); // Ricarica i preferiti dopo eventuali modifiche
                    },
                    child: BookGridCard(
                      book: book,
                      onFavoriteToggle: _loadFavorites, // aggiorna la lista se il libro viene rimosso dai preferiti
                    ),
                  );
                },
              ),
      ),
    );
  }
}
