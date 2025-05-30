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
    final screen = MediaQuery.of(context).size;
    final double spacing = screen.width * 0.04;
    final double padding = screen.width * 0.05;
    final maxCardWidth = 200.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Popular Books",
          style: const TextStyle(fontWeight: FontWeight.bold),
         
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child:
            popularBooks.isEmpty
                ? const Center(child: Text("No popular books available"))
                : GridView.builder(
                  itemCount: popularBooks.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: maxCardWidth,
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
                        _loadPopularBooks(); 
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
