// import invariati
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../models/category.dart';
import '../../models/book.dart';
import '../../data/database_helper.dart';
import 'category_detail_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> categories = [];
  List<Book> allBooks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedCategories = await DatabaseHelper.instance.getAllCategories();
    final loadedBooks = await DatabaseHelper.instance.getAllBooks();
    setState(() {
      categories = loadedCategories;
      allBooks = loadedBooks;
    });
  }

  int _countBooksForCategory(Category category) {
    return allBooks.where((book) => book.categoryId == category.id).length;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    String newName = '';
    Color newColor = Colors.black;
    String? errorText;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 16,
        ),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: isWideScreen ? 300 : 250,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: isWideScreen ? 0.85 : 0.75,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            final bookCount = _countBooksForCategory(category);
            return GestureDetector(
              onTap: () async {
                final wasDeleted = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryDetailPage(category: category),
                  ),
                );
                if (wasDeleted == true) {
                  await _loadData();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: category.color ?? Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "$bookCount book${bookCount == 1 ? '' : 's'}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7C7C7C),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              errorText = null;
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
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Category name',
                                errorText: errorText,
                              ),
                              onChanged: (value) {
                                newName = value;
                                final exists = categories.any(
                                  (c) => c.name.trim().toLowerCase() ==
                                      value.trim().toLowerCase(),
                                );
                                setState(() {
                                  errorText = exists
                                      ? 'A category with this name already exists'
                                      : null;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              title: const Text('Pick a color'),
                              trailing: CircleAvatar(backgroundColor: newColor),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Create Category",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
