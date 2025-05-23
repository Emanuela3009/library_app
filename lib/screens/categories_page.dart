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

  Future<void> _addCategory(String name, Color color) async {
    final newCategory = Category(name: name.trim(), colorValue: color.value);
    await DatabaseHelper.instance.insertCategory(newCategory);
    _loadData(); // ricarica dopo inserimento
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            final bookCount = _countBooksForCategory(category);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryDetailPage(category: category),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
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
                    const SizedBox(height: 8),
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color.fromARGB(255, 22, 78, 199),
                      ),
                    ),
                    Text(
                      "$bookCount book${bookCount == 1 ? '' : 's'}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color.fromARGB(255, 22, 78, 199),
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
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () {
              String newName = '';
              Color newColor = const Color.fromARGB(255, 106, 147, 221);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'New Category',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Category name',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 19, 39, 168),
                                  fontWeight: FontWeight.w500,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 19, 39, 168),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 22, 78, 199),
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (value) => newName = value,
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              title: Text(
                                'Pick a color',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 22, 78, 199),
                                ),
                              ),
                              trailing: CircleAvatar(backgroundColor: newColor),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text(
                                          'Choose a color',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            color: const Color.fromARGB(
                                              255,
                                              30,
                                              42,
                                              120,
                                            ),
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: ColorPicker(
                                            pickerColor: newColor,
                                            onColorChanged: (color) {
                                              setState(() => newColor = color);
                                            },
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: Text(
                                              'OK',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelSmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: const Color.fromARGB(255, 22, 78, 199),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (newName.trim().isEmpty) return;
                          await _addCategory(newName, newColor);
                          Navigator.pop(context);
                        },
                        child: const Text('Create'),
                      ),
                    ],
                  );
                },
              );
            },
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
