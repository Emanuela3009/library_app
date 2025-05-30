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
    final books = all
    .where((b) => b.isUserBook)
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
    setState(() {
      allBooks = books;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.04;
    final maxCardWidth = 200.0;

    return Scaffold(
      appBar: AppBar(title: const Text("Library")),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: allBooks.isEmpty
            ? const Center(child: Text("No books added yet"))
            : GridView.builder(
                itemCount: allBooks.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                 maxCrossAxisExtent: maxCardWidth,
                  mainAxisSpacing: padding,
                  crossAxisSpacing: padding,
                  childAspectRatio: 3 / 4.5,
                ),
                itemBuilder: (context, index) {
                  final book = allBooks[index];
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailPage(book: book),
                                              ),
                        );
                        if (result == true) {
                          setState(() {
                            allBooks.clear(); 
                          });
                          await _loadBooks(); 
                        }
                    },
                    child: BookGridCard(
                      key: ValueKey('${book.id}_${DateTime.now().millisecondsSinceEpoch}'),
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