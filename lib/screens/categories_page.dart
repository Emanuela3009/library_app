import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../models/category.dart';
import '../../data/database_helper.dart';
import 'category_detail_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final loaded = await DatabaseHelper.instance.getAllCategories();
    setState(() {
      categories = loaded;
    });
  }

  Future<void> _addCategory(String name, Color color) async {
    final newCategory = Category(
      name: name.trim(),
      colorValue: color.value,
    );
    await DatabaseHelper.instance.insertCategory(newCategory);
    _loadCategories(); // ricarica categorie dopo inserimento
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Titolo gestito dal tema → headlineLarge
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
                    )
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Riquadro colorato al posto dell'immagine
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
                    // Nome categoria → usa il titolo dal tema
                    Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color.fromARGB(255, 22, 78, 199), // nuovo blu per il titolo categoria
                    ),
                    ),
                    // Sottotitolo → usa testo corpo medio dal tema
                    Text(
                    "Category",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color.fromARGB(255, 22, 78, 199), // blu scuro
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
              Color newColor = const Color.fromARGB(255, 106, 147, 221);  //colore del picker

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
                          decoration: InputDecoration(
                            labelText: 'Category name',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 19, 39, 168),
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 19, 39, 168), // linea per immettere 
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 22, 78, 199), // la stessa linea ma più spessa quando ci clicchiamo sopra per immettere il testo
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
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 18, // più grande di bodyMedium
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 22, 78, 199),
                                ),
                              ),
                              trailing: CircleAvatar(  //cerchio per selezionare il colore dalla palette
                                backgroundColor: newColor,
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'Choose a color',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: const Color.fromARGB(255, 30, 42, 120), // blu scuro
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
                                          onPressed: () => Navigator.pop(context),
                                          child: Text(
                                            'OK',
                                            style: Theme.of(context).textTheme.labelSmall,
                                          ),
                                        )
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
            // Il resto già prende stile dal tema globale per i pulsanti
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
