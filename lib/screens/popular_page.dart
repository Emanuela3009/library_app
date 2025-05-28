import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import 'book_detail_page.dart';
import '../widgets/book_grid_card.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  List<Book> popularBooks = [];

  @override
  void initState() {
    super.initState();
    _loadPopularBooks();
  }

  Future<void> _loadPopularBooks() async {
    final books = await DatabaseHelper.instance.getAllBooks();
    setState(() {
      popularBooks = books
          .where((b) => b.isUserBook == false)
          .toList()
        ..sort((a, b) {
          final regex = RegExp(r'^\d+');
          final aMatch = regex.stringMatch(a.title);
          final bMatch = regex.stringMatch(b.title);

          if (aMatch != null && bMatch != null) {
            return int.parse(aMatch).compareTo(int.parse(bMatch)); // numerico crescente
          } else if (aMatch != null) {
            return -1; // a è numerico, viene prima
          } else if (bMatch != null) {
            return 1; // b è numerico, viene prima
          } else {
            return a.title.toLowerCase().compareTo(b.title.toLowerCase()); // alfabetico
          }
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final double spacing = screen.width * 0.04;
    final double padding = screen.width * 0.05;
    final double fontScale = screen.width / 400;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Popular Books",
          style: TextStyle(fontSize: 18 * fontScale),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child:
            popularBooks.isEmpty
                ? const Center(child: Text("No popular books available"))
                : GridView.builder(
                  itemCount: popularBooks.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (screen.width >= 1200)
                        ? 5
                        : (screen.width >= 900)
                            ? 4
                            : (screen.width >= 600)
                                ? 3
                                : 2,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    childAspectRatio: 3 / 4.5,
                  ),
                  itemBuilder: (context, index) {
                    final book = popularBooks[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailPage(book: book),
                          ),
                        );
                        _loadPopularBooks(); // aggiorna al ritorno
                      },
                      child: BookGridCard(
                        book: book,
                        onFavoriteToggle: _loadPopularBooks,
                      ),
                    );
                  },
                )
      ),
    );
  }
}
