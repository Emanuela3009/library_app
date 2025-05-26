import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../models/book.dart';
import '../../data/database_helper.dart';
import '../../widgets/book_grid_card.dart'; // Importa il widget riutilizzabile
import 'book_detail_page.dart';

class CategoryDetailPage extends StatefulWidget {
  final Category category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final allBooks = await DatabaseHelper.instance.getAllBooks();
    setState(() {
      books = allBooks.where((book) => book.categoryId == widget.category.id).toList();
    });
  }

  Future<void> _deleteCategory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Category"),
        content: const Text("Are you sure you want to delete this category?\nBooks will not be deleted."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      for (var book in books) {
        book.categoryId = null;
        await DatabaseHelper.instance.insertBook(book);
      }
      await DatabaseHelper.instance.deleteCategory(widget.category.id!);
      if (context.mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Category deleted")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    final padding = 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteCategory,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have ${books.length} book${books.length == 1 ? '' : 's'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: GridView.builder(
                  itemCount: books.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: isWideScreen ? 300 : 250,
                    mainAxisSpacing: padding,
                    crossAxisSpacing: padding,
                    childAspectRatio: 3 / 4.5, // stesso ratio di BookGridCard
                  ),
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailPage(book: book),
                          ),
                        );
                        _loadBooks(); // aggiorna lista dopo modifica
                      },
                      child: BookGridCard(
                        book: book,
                        onFavoriteToggle: _loadBooks,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}