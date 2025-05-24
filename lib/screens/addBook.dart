import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final plotController = TextEditingController();

  String selectedGenre = 'Fantasy';
  String selectedState = 'To Read';

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
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
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Book")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: plotController,
                decoration: const InputDecoration(labelText: 'Plot'),
                maxLines: 3,
              ),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField(
                value: selectedGenre,
                decoration: const InputDecoration(labelText: 'Genre'),
                items:
                    ['Fantasy', 'Romance', 'Adventure', 'Sci-Fi', 'Horror']
                        .map(
                          (genre) => DropdownMenuItem(
                            value: genre,
                            child: Text(
                              genre,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => selectedGenre = value!),
              ),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField(
                value: selectedState,
                decoration: const InputDecoration(labelText: 'State'),
                items:
                    ['To Read', 'Reading', 'Completed']
                        .map(
                          (state) => DropdownMenuItem(
                            value: state,
                            child: Text(
                              state,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => selectedState = value!),
              ),
              SizedBox(height: screenHeight * 0.02),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _showImageSourceOptions,
                  child:
                      _selectedImage != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              height: 180,
                              width: screenWidth * 0.5,
                              fit: BoxFit.contain,
                            ),
                          )
                          : Container(
                            height: screenHeight * 0.15,
                            width: screenWidth * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: const Center(
                              child: Text("Tap to add cover image"),
                            ),
                          ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newBook = Book(
                      title: titleController.text,
                      author: authorController.text,
                      genre: selectedGenre,
                      plot: plotController.text,
                      imagePath:
                          _selectedImage?.path ??
                          'assets/books/placeholder.jpg',
                      userState: selectedState,
                      isUserBook: true, // ✅ IMPORTANTE
                      rating: 0,
                      dateCompleted: selectedState == 'Completed' ? DateTime.now() : null,
                    );
                    await DatabaseHelper.instance.insertBook(newBook);
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text("Add book"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
