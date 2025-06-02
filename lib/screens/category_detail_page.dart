import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../models/category.dart';
import '../../data/database_helper.dart';
import '../../widgets/book_grid_card.dart';
import 'book_detail_page.dart';

class CategoryDetailPage extends StatefulWidget {
  final Category category;

  // La schermata riceve una categoria da mostrare in dettaglio
  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  // Lista dei libri appartenenti alla categoria selezionata
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks(); // Caricamento iniziale dei libri associati alla categoria
  }

  // Metodo per caricare i libri che appartengono a questa categoria
  Future<void> _loadBooks() async {
    final allBooks = await DatabaseHelper.instance.getAllBooks();
    setState(() {
      // Filtra solo quelli con lo stesso categoryId
      books = allBooks.where((book) => book.categoryId == widget.category.id).toList();
    });
  }

  // Metodo per eliminare una categoria (senza eliminare i libri associati)
  Future<void> _deleteCategory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Category"),
        content: const Text(
          "Are you sure you want to delete this category?\nBooks will not be deleted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Rimuove il collegamento alla categoria da ciascun libro
      for (var book in books) {
        book.categoryId = null;
        await DatabaseHelper.instance.insertBook(book); // aggiorna libro
      }
      // Elimina la categoria dal database
      await DatabaseHelper.instance.deleteCategory(widget.category.id!);

      if (context.mounted) {
        Navigator.pop(context, true); // torna alla schermata precedente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category deleted")),
        );
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
            onPressed: _deleteCategory, // bottone per eliminare la categoria
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Testo che mostra quanti libri appartengono a questa categoria
            Text(
              'You have ${books.length} book${books.length == 1 ? '' : 's'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Griglia dei libri appartenenti alla categoria
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: GridView.builder(
                  itemCount: books.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: isWideScreen ? 300 : 250,
                    mainAxisSpacing: padding,
                    crossAxisSpacing: padding,
                    childAspectRatio: 3 / 4.5, // proporzione card
                  ),
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return GestureDetector(
                      onTap: () async {
                        // Al tap si apre la BookDetailPage del libro
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailPage(book: book),
                          ),
                        );
                        if (result is Book) {
                          _loadBooks(); // Ricarica lista se il libro è stato modificato o eliminato
                        }
                      },
                      child: BookGridCard(
                        book: book,
                        onFavoriteToggle: _loadBooks, // utile per aggiornare stato preferiti
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
