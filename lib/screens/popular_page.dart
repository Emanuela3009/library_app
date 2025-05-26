import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import 'book_detail_page.dart';

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
      popularBooks = books.where((b) => b.isUserBook == false).toList();
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
                    crossAxisCount: (screen.width ~/ 200).clamp(2, 4),
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    childAspectRatio: screen.width > 600 ? 0.6 : 0.68,
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
                      child: Container(
                        padding: EdgeInsets.all(spacing * 0.5),
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      book.imagePath,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Icon(
                                      book.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          book.isFavorite
                                              ? Colors.pink
                                              : Colors.grey,
                                      size: screen.width * 0.05,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: spacing * 0.5),
                            Text(
                              book.title,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14 * fontScale,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              book.author,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 13 * fontScale,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '⭐ ${book.rating?.toStringAsFixed(1) ?? '0.0'}/5',
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 13 * fontScale,
                              ),
                            ),
                            Text(
                              book.userState ?? '',
                              style: TextStyle(
                                fontSize: 12 * fontScale,
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
