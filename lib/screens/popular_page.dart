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
    return Scaffold(
      appBar: AppBar(title: const Text("Popular Books")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            popularBooks.isEmpty
                ? const Center(child: Text("No popular books available"))
                : GridView.builder(
                  itemCount: popularBooks.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.68,
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
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              book.title,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
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
                              '⭐ ${book.rating?.toStringAsFixed(1) ?? '0.0'}/5',
                              style: const TextStyle(
                                color: Colors.purple,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              book.userState ?? '',
                              style: const TextStyle(
                                fontSize: 12,
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
