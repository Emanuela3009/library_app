import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AddBookPage extends StatefulWidget {
  final Book? book;
  const AddBookPage({super.key, this.book});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final plotController = TextEditingController();
  String selectedState = 'To Read'; 
  String selectedGenre = 'Fantasy';
  DateTime? completedDate;
  File? _selectedImage;
  String? _imageFileName; 
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      final book = widget.book!;
      titleController.text = book.title;
      authorController.text = book.author;
      plotController.text = book.plot;
      selectedGenre = book.genre;
      selectedState = widget.book?.userState ?? 'To Read';
      completedDate = book.dateCompleted; 

      if (!book.imagePath.startsWith('assets')) {
        _imageFileName = book.imagePath; 
      }
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'book_cover_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
      final savedImagePath = path.join(appDir.path, fileName);
      final savedImage = await File(pickedFile.path).copy(savedImagePath);

      setState(() {
        _selectedImage = savedImage;
        _imageFileName = fileName; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    final verticalSpace = screenSize.height * 0.02;
    final imageHeight = isLandscape ? screenSize.height * 0.3 : screenSize.height * 0.25;
    final imageWidth = screenSize.width * (isLandscape ? 0.4 : 0.5);
    final padding = EdgeInsets.symmetric(horizontal: screenSize.width * 0.05);

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Book' : 'Add Book')),
      body: Padding(
        padding: padding,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: verticalSpace),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              SizedBox(height: verticalSpace),
              TextFormField(
                controller: plotController,
                decoration: const InputDecoration(labelText: 'Plot'),
              ),
              SizedBox(height: verticalSpace),
              DropdownButtonFormField<String>(
                value: selectedGenre,
                items: ['Adventure', 'Biography', 'Comic', 'Crime', 'Drama', 'Fable', 'Fantasy', 'Gothic', 'History', 'Horror', 'Mystery', 'Poetry', 'Romance',
                'Satire', 'Sci-Fi', 'Thriller', 'Tragedy',]
                    .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedGenre = value!);
                },
                decoration: const InputDecoration(
                  labelText: 'Genre',
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
              SizedBox(height: verticalSpace),
              DropdownButtonFormField<String>(
                value: selectedState,
                items: ['To Read', 'Reading', 'Completed']
                    .map((state) => DropdownMenuItem(value: state, child: Text(state)))
                    .toList(),
                onChanged: (newValue) async {
                  if (newValue == 'Completed') {
                    final selectedDate = await _showMonthYearPicker(context, initialDate: completedDate);
                    if (selectedDate != null) {
                      setState(() {
                        selectedState = 'Completed';
                        completedDate = selectedDate;
                      });
                    }
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
                      .toList(); 
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
              SizedBox(height: verticalSpace),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _showImageSourceOptions,
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                            height: imageHeight,
                            width: imageWidth,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Container(
                          height: imageHeight,
                          width: imageWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Center(child: Text("Tap to add cover image", maxLines: 2)),
                        ),
                ),
              ),
              SizedBox(height: verticalSpace),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final existingBooks = await DatabaseHelper.instance.getAllBooks();
                    final newTitle = titleController.text.trim().toLowerCase();

                    final isDuplicate = existingBooks.any((book) {
                      if (widget.book != null && book.id == widget.book!.id) return false;
                      return book.title.trim().toLowerCase() == newTitle;
                    });

                    if (isDuplicate) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("A book with this title already exists.")),
                    );
                    return;
                    }

                    final updatedBook = Book(
                      id: widget.book?.id,
                      title: titleController.text,
                      author: authorController.text,
                      genre: selectedGenre,
                      plot: plotController.text,
                      imagePath: _imageFileName ?? widget.book?.imagePath ?? 'assets/books/placeholder.jpg',
                      userState: selectedState.isNotEmpty ? selectedState : widget.book?.userState ?? 'To Read',
                      isUserBook: true,
                      isFavorite: widget.book?.isFavorite ?? false,
                      categoryId: widget.book?.categoryId,
                      rating: widget.book?.rating ?? 0,
                      comment: widget.book?.comment,
                      dateCompleted: selectedState == 'Completed' ? completedDate : null,
                    );
                    await DatabaseHelper.instance.insertBook(updatedBook);
                    Navigator.pop(context, updatedBook);
                  }
                },
                icon: Icon(isEditing ? Icons.save : Icons.add),
                label: Text(isEditing ? "Save changes" : "Add book"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<DateTime?> _showMonthYearPicker(BuildContext context, {DateTime? initialDate} ) async {
  final baseDate = initialDate ?? DateTime.now();
  int selectedMonth = baseDate.month;
  int selectedYear = baseDate.year;

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
            child: const Text("Cancel")
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