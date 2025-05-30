import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../models/book.dart';
import '../../data/database_helper.dart';
import 'category_detail_page.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  // Lista delle categorie e dei libri caricati dal database
  List<Category> categories = [];
  List<Book> allBooks = [];

  // Variabili per la creazione di una nuova categoria
  String newName = '';
  Color newColor = const Color.fromARGB(255, 0, 0, 0);
  String? errorText;

  @override
  void initState() {
    super.initState();
    _loadData(); // Carichiamo categorie e libri dal DB al primo build
  }

  // Caricamento delle categorie e dei libri dal database
  Future<void> _loadData() async {
    final loadedCategories = await DatabaseHelper.instance.getAllCategories();
    final loadedBooks = await DatabaseHelper.instance.getAllBooks();
    setState(() {
      categories = loadedCategories;
      allBooks = loadedBooks;
    });
  }

  // Conta quanti libri appartengono a una determinata categoria
  int _countBooksForCategory(Category category) {
    return allBooks.where((book) => book.categoryId == category.id).length;
  }

  // Mostra il dialog per aggiungere una nuova categoria
  void _showAddCategoryDialog(double fontSizeTitle) {
    errorText = null;
    newName = '';
    newColor = const Color.fromARGB(255, 0, 0, 0);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('New Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo di input per il nome della nuova categoria
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Category name',
                      errorText: errorText,
                    ),
                    onChanged: (value) {
                      newName = value;
                      // Verifica se la categoria esiste già (case-insensitive)
                      final exists = categories.any(
                        (c) => c.name.trim().toLowerCase() == value.trim().toLowerCase(),
                      );
                      setState(() {
                        errorText = exists ? 'A category with this name already exists' : null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Pulsante per selezionare un colore tramite color picker
                  ListTile(
                    title: const Text('Pick a color'),
                    trailing: CircleAvatar(backgroundColor: newColor),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Choose a color'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: newColor,
                              onColorChanged: (color) {
                                setState(() => newColor = color);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (newName.trim().isEmpty || errorText != null) return;
                    // Creazione della nuova categoria
                    final newCategory = Category(
                      name: newName.trim(),
                      colorValue: newColor.value,
                    );
                    await DatabaseHelper.instance.insertCategory(newCategory);
                    await _loadData();
                    Navigator.pop(context);
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Widget per creare la card visiva di una categoria
  Widget _buildCategoryCard(Category category, double fontSizeTitle, double fontSizeSubtitle) {
    final bookCount = _countBooksForCategory(category);

    return GestureDetector(
      onTap: () async {
        final wasDeleted = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => CategoryDetailPage(category: category)),
        );
        if (wasDeleted == true) await _loadData();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Riquadro colorato della categoria
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: category.color ?? Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: fontSizeTitle,
                color: Colors.black,
              ),
            ),
            Text(
              "$bookCount book${bookCount == 1 ? '' : 's'}",
              style: TextStyle(
                fontSize: fontSizeSubtitle,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final isTablet = screen.shortestSide >= 600;
    final double padding = screen.width * 0.04;
    final double fontSizeTitle = isTablet ? 20 : 16;
    final double fontSizeSubtitle = isTablet ? 16 : 14;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calcolo dinamico del numero di colonne nel GridView
          final crossAxisCount = isTablet
              ? (screen.width ~/ 250).clamp(2, 6)
              : 2;

          return Scrollbar(
            thumbVisibility: true,
            thickness: 4,
            radius: const Radius.circular(6),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Griglia di categorie
                    GridView.builder(
                      itemCount: categories.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: isTablet ? 260 : 200,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) =>
                          _buildCategoryCard(categories[index], fontSizeTitle, fontSizeSubtitle),
                    ),
                    const SizedBox(height: 20),
                    // Pulsante per creare una nuova categoria
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSizeTitle,
                          ),
                        ),
                        onPressed: () => _showAddCategoryDialog(fontSizeTitle),
                        child: const Text('Create Category'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
