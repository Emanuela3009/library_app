import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/book.dart';
import '../models/category.dart';
import '../data/database_helper.dart';
import 'package:intl/intl.dart';
import 'addBook.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late Book book;
  String? _fullImagePath;

  List<Category> allCategories = [];
  int rating = 0;
  String comment = '';
  String selectedState = 'To Read';
  final commentController = TextEditingController();
  DateTime? completedDate;
  bool? _fileExists;

  @override
  void initState() {
    super.initState();
    book = widget.book;
    selectedState = _normalizeState(book.userState) ?? 'To Read';
    rating = book.rating ?? 0;
    commentController.text = book.comment ?? '';
    _loadCategories();
    _checkImageFileExists();
    completedDate = book.dateCompleted;
  }

 Future<void> _checkImageFileExists() async {
  final path = await book.getImageFullPath();
  if (path == null) {
      setState(() {
      _fileExists = null;
      _fullImagePath = null;
    });
     return;
  } 
    final file = File(path);
    final exists = await file.exists();

     setState(() {
      _fileExists = exists;
      _fullImagePath = exists ? path : null;
    });
  }


  Future<void> _loadCategories() async {
    final categories = await DatabaseHelper.instance.getAllCategories();
    setState(() {
      allCategories = categories;
    });
  }

  void _showCategoryDialog(BuildContext context) {
    Category? selectedCategory;
    String newCategoryName = '';
    Color selectedColor = Colors.blueGrey;
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Choose or Create Category',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Select existing category',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Category>(
                        value: selectedCategory,
                        isExpanded: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: allCategories
                            .map((cat) => DropdownMenuItem(value: cat, child: Text(cat.name)))
                            .toList(),
                        onChanged: (val) => setState(() => selectedCategory = val),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Create new category',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter new category name',
                          errorText: errorText,
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: (val) {
                          newCategoryName = val;
                          final exists = allCategories.any((c) =>
                              c.name.trim().toLowerCase() == newCategoryName.trim().toLowerCase());
                          setState(() => errorText = exists ? 'A category with this name already exists' : null);
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Color:'),
                          const SizedBox(width: 8),
                          CircleAvatar(backgroundColor: selectedColor, radius: 12),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Pick a color'),
                                  content: BlockPicker(
                                    pickerColor: selectedColor,
                                    onColorChanged: (color) {
                                      setState(() => selectedColor = color);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                            child: const Text('Choose'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () async {
                              if (selectedCategory == null &&
                                  newCategoryName.trim().isNotEmpty &&
                                  errorText == null) {
                                final newCat = Category(name: newCategoryName.trim(), colorValue: selectedColor.value);
                                final id = await DatabaseHelper.instance.insertCategory(newCat);
                                widget.book.categoryId = id;
                              } else if (selectedCategory != null) {
                                widget.book.categoryId = selectedCategory!.id;
                              } else {
                                return;
                              }
                              await DatabaseHelper.instance.insertBook(widget.book);
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Book added to "${selectedCategory?.name ?? newCategoryName}"')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Book"),
        content: const Text("Are you sure you want to delete this book?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DatabaseHelper.instance.deleteBook(widget.book.id!);
              if (!context.mounted) return;
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Book deleted")));
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<DateTime?> _showMonthYearPicker(BuildContext context) async {
    final initialDate = widget.book.dateCompleted ?? DateTime.now();
    int selectedMonth = initialDate.month;
    int selectedYear = initialDate.year;

    return showDialog<DateTime>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select completion month"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    value: selectedMonth,
                    onChanged: (value) => setState(() => selectedMonth = value!),
                    items: List.generate(
                      12,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text(DateFormat.MMMM().format(DateTime(0, index + 1))),
                      ),
                    ),
                  ),
                  DropdownButton<int>(
                    value: selectedYear,
                    onChanged: (value) => setState(() => selectedYear = value!),
                    items: List.generate(5, (index) {
                      final year = DateTime.now().year - index;
                      return DropdownMenuItem(value: year, child: Text("$year"));
                    }),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, DateTime(selectedYear, selectedMonth)),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final screenWidth = screen.width;
    final screenHeight = screen.height;
    final isLandscape = screenWidth > screenHeight;
    final horizontalPadding = screenWidth * 0.05;
    final imageHeight = screenHeight * 0.6;
    final double spacing = screen.height * 0.02;
    final double iconSize = screen.width * 0.07;

    return WillPopScope(
      onWillPop: () async {
        book.comment = commentController.text;
        book.rating = rating;
        if (selectedState == 'Completed' && book.userState != 'Completed') {
          book.dateCompleted = completedDate;
        }
        book.userState = selectedState;
        await DatabaseHelper.instance.insertBook(book);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
           if (book.isUserBook)
            IconButton(
                icon: Icon(Icons.edit, size: iconSize,),
                onPressed: book.isUserBook ? () async {
                  //Prima salva le modifiche locali
                  book.comment = commentController.text;
                  book.rating = rating;
                  if (selectedState == 'Completed' && book.userState != 'Completed') {
                    book.dateCompleted = completedDate;
                  }
                  book.userState = selectedState;
                  await DatabaseHelper.instance.insertBook(book);

                  //Poi ricarica il libro aggiornato dal DB
                  final refreshedBook = await DatabaseHelper.instance.getBookById(book.id!);
                  if (refreshedBook == null) return;

                  // ✏️ Vai alla schermata di modifica con il libro aggiornato
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddBookPage(book: refreshedBook),
                    ),
                  );

                  // Quando torni, aggiorna la UI
                  if (result is Book) {
                    final updated = await DatabaseHelper.instance.getBookById(result.id!);
                    if (updated != null) {
                      setState(() {
                        book = updated;
                        selectedState = _normalizeState(updated.userState) ?? 'To Read';
                        rating = updated.rating ?? 0;
                        commentController.text = updated.comment ?? '';
                        _checkImageFileExists();
                      });
                    }
                  }
                } : null ,
              ),
            if (book.id != null)
              IconButton(icon: Icon(Icons.delete, size: iconSize), onPressed: _confirmDelete),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                book.comment = commentController.text;
                book.rating = rating;
                if (selectedState == 'Completed' && book.userState != 'Completed') {
                  book.dateCompleted = completedDate;
                }
                book.userState = selectedState;
                DatabaseHelper.instance.insertBook(book);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: spacing),
          child: ListView(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _fileExists == null
                        ? Image.asset(
                            book.imagePath,
                            height: imageHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : (_fileExists == true
                            ? Image.file(
                                File(_fullImagePath!), // ✅ QUI
                                height: imageHeight,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/books/placeholder.jpg',
                                height: imageHeight,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(80),
                      onTap: () async {
                        setState(() => book.isFavorite = !book.isFavorite);
                        await DatabaseHelper.instance.insertBook(book);
                      },
                      child: Icon(
                        book.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.pink,
                        size: iconSize,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Text(book.title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(book.author, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              SizedBox(height: spacing),
              Text(book.plot, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.justify),
              SizedBox(height: spacing),
              Text("Your review", style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: iconSize,
                    ),
                    onPressed: () async {
                      setState(() {
                        rating = index + 1;
                        book.rating = rating;
                      });
                      await DatabaseHelper.instance.insertBook(book);
                    },
                  ),
                ),
              ),
              SizedBox(height: spacing),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Leave a comment',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: spacing),
              DropdownButtonFormField<String>(
                value: selectedState,
                items: ['To Read', 'Reading', 'Completed']
                    .map((state) => DropdownMenuItem(value: state, child: Text(state)))
                    .toList(),
                onChanged: (newValue) async {
                  if (newValue == 'Completed') {
                    final selectedDate = await _showMonthYearPicker(context);
                    if (selectedDate != null) {
                      setState(() {
                        selectedState = 'Completed';
                        completedDate = selectedDate;
                      });
                    }
                    // Se viene premuto cancel, non faccio nulla
                  } else {
                    setState(() {
                      selectedState = newValue!;
                      completedDate = null;
                    });
                  }
                },
                selectedItemBuilder: (context) {
                  return ['To Read', 'Reading', 'Completed']
                      .map((state) => Text(selectedState))
                      .toList(); // forza la visualizzazione coerente
                },
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  isDense: true,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: spacing),
              ElevatedButton.icon(
                onPressed: () => _showCategoryDialog(context),
                icon: const Icon(Icons.category),
                label: const Text("Choose Category"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MonthYear {
  final int month;
  final int year;

  MonthYear({required this.month, required this.year});
}

String? _normalizeState(String? input) {
  if (input == null) return null;
  switch (input.trim().toLowerCase()) {
    case 'to read':
      return 'To Read';
    case 'reading':
      return 'Reading';
    case 'completed':
      return 'Completed';
    default:
      return null;
  }
}