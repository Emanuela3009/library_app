import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';

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
  
  File? _selectedImage;
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
      if (!book.imagePath.startsWith('assets')) {
        _selectedImage = File(book.imagePath);
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
      setState(() => _selectedImage = File(pickedFile.path));
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
                maxLines: 3,
              ),
              SizedBox(height: verticalSpace),
              DropdownButtonFormField(
                value: selectedGenre,
                decoration: const InputDecoration(labelText: 'Genre'),
                items: ['Fantasy', 'Romance', 'Adventure', 'Sci-Fi', 'Horror']
                    .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
                    .toList(),
                onChanged: (value) => setState(() => selectedGenre = value!),
              ),
              SizedBox(height: verticalSpace),
              DropdownButtonFormField<String>(
                value: selectedState,
                items: ['To Read', 'Reading', 'Completed']
                    .map((state) => DropdownMenuItem(value: state, child: Text(state)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedState = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'State'),
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
                          child: const Center(child: Text("Tap to add cover image", maxLines: 2,)),
                        ),
                ),
              ),
              SizedBox(height: verticalSpace),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedBook = Book(
                      id: widget.book?.id,
                      title: titleController.text,
                      author: authorController.text,
                      genre: selectedGenre,
                      plot: plotController.text,
                      imagePath: _selectedImage?.path ?? widget.book?.imagePath ?? 'assets/books/placeholder.jpg',
                      userState: selectedState,
                      isUserBook: true,
                      isFavorite: widget.book?.isFavorite ?? false,
                      categoryId: widget.book?.categoryId,
                      rating: widget.book?.rating ?? 0,
                      comment: widget.book?.comment,
                      dateCompleted: selectedState == 'Completed'
                          ? (widget.book?.dateCompleted ?? DateTime.now())
                          : null,
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