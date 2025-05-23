import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/book.dart';
import '../models/category.dart';
import '../data/database_helper.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  List<Category> allCategories = [];
  int rating = 0;
  String comment = '';
  String selectedState = 'To Read';
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final book = widget.book;
    selectedState = _normalizeState(book.userState) ?? 'To Read';
    rating = book.rating ?? 0;
    commentController.text = book.comment ?? '';
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await DatabaseHelper.instance.getAllCategories();
    setState(() {
      allCategories = categories;
    });
  }

  void _showCategoryDialog(BuildContext context) {
    final theme = Theme.of(context);
    Category? selectedCategory;
    String newCategoryName = '';
    Color selectedColor = Colors.grey.shade400;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Choose or Create Category',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2A78),
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Category>(
                      value: selectedCategory,
                      hint: Text(
                        'Select existing category',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1E2A78),
                            width: 2,
                          ),
                        ),
                      ),
                      items:
                          allCategories.map((cat) {
                            return DropdownMenuItem<Category>(
                              value: cat,
                              child: Text(cat.name),
                            );
                          }).toList(),
                      onChanged:
                          (val) => setState(() => selectedCategory = val),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'New category name',
                      ),
                      onChanged: (value) => newCategoryName = value,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text("Color: "),
                        CircleAvatar(backgroundColor: selectedColor),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Pick a color"),
                                  content: SingleChildScrollView(
                                    child: BlockPicker(
                                      pickerColor: selectedColor,
                                      onColorChanged: (color) {
                                        setState(() => selectedColor = color);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text("Choose"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedCategory == null &&
                    newCategoryName.trim().isNotEmpty) {
                  final newCat = Category(
                    name: newCategoryName.trim(),
                    colorValue: selectedColor.value,
                  );
                  final id = await DatabaseHelper.instance.insertCategory(
                    newCat,
                  );
                  widget.book.categoryId = id;
                } else if (selectedCategory != null) {
                  widget.book.categoryId = selectedCategory!.id;
                }

                await DatabaseHelper.instance.insertBook(widget.book);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Book assigned to ${selectedCategory?.name ?? newCategoryName}',
                    ),
                  ),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Book"),
            content: const Text("Are you sure you want to delete this book?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await DatabaseHelper.instance.deleteBook(widget.book.id!);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Book deleted")));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = MediaQuery.of(context).size.width * 0.05;

    return WillPopScope(
      onWillPop: () async {
        book.comment = commentController.text;
        book.rating = rating;
        book.userState = selectedState;
        await DatabaseHelper.instance.insertBook(book);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (book.id != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _confirmDelete,
              ),
            
            IconButton(
              icon: Icon(
                widget.book.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.pink,
              ),
              onPressed: () async {
                setState(() {
                  widget.book.isFavorite = !widget.book.isFavorite;
                });
                await DatabaseHelper.instance.insertBook(widget.book);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(widget.book.isFavorite
                      ? 'Added to favorites'
                      : 'Removed from favorites'),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                book.comment = commentController.text;
                book.rating = rating;
                book.userState = selectedState;
                DatabaseHelper.instance.insertBook(book);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: ListView(
            children: [
              Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    book.imagePath,
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () async {
                      setState(() {
                        widget.book.isFavorite = !widget.book.isFavorite;
                      });
                      await DatabaseHelper.instance.insertBook(widget.book);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(widget.book.isFavorite
                              ? 'Added to favorites'
                              : 'Removed from favorites'),
                        ),
                      );
                    },
                    child: Icon(
                      widget.book.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pink,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                book.plot,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 24),
              Text(
                "Your review",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () async {
                      setState(() {
                        rating = index + 1;
                        widget.book.rating = rating;
                      });
                      await DatabaseHelper.instance.insertBook(widget.book);
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Leave a comment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: selectedState,
                items:
                    ['To Read', 'Reading', 'Completed']
                        .map(
                          (state) => DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedState = value!;
                  });
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
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
