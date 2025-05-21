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
  final _formKey = GlobalKey<FormState>();   // serve per validare il form quando si preme “Add book”.

  // Controller per i campi , Servono per leggere il contenuto dei campi quando si preme il bottone.
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final plotController = TextEditingController();

  // Dropdown, valori di default dei menu a tendina 
  String selectedGenre = 'Fantasy';
  String selectedState = 'To Read';

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();


void _showImageSourceOptions() {   //funzione che viene chiamata quando l utente vuole scegliere un immagine
    showModalBottomSheet(    //riquadro  in basso per far scegliere all utente al posto del pop up 
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(   //oggetti posizionati in colonna
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);  //chiama la funzione descritta in seguito
                  Navigator.pop(context);  //chiude il pop up 
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);  //chiama la funzione descritta in seguito
                  Navigator.pop(context); //chiude il pop up 
                },
              ),
            ],
          ),
        );
      },
    );
  }
  //funzione che gestisce la selezione dell’immagine, da fotocamera o galleria
  Future<void> _pickImage(ImageSource source) async {   //asincrona
    final pickedFile = 
        await _picker.pickImage(source: source, imageQuality: 80); //await, aspetta che l utente scelga o scatti la foto
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
      body: 
        Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(   //per rendere scrollabile il form su dispositivi piccoli 
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),

               SizedBox(height: screenHeight *0.02 ),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),

               SizedBox(height: screenHeight *0.02 ),
              TextFormField(
                controller: plotController,
                decoration: const InputDecoration(labelText: 'Plot'),
                maxLines: 3,  
              ),

               SizedBox(height: screenHeight *0.02),
              DropdownButtonFormField(
                value: selectedGenre,
                decoration: const InputDecoration(labelText: 'Genre'),
                items: ['Fantasy', 'Romance', 'Adventure', 'Sci-Fi', 'Horror']
                    .map((genre) => DropdownMenuItem(value: genre, child: Text(genre,
                     style: Theme.of(context).textTheme.bodyLarge,)))
                    .toList(),
                onChanged: (value) => setState(() => selectedGenre = value!),
              ),

               SizedBox(height: screenHeight *0.02 ),
              DropdownButtonFormField(
                value: selectedState,
                decoration: const InputDecoration(labelText: 'State'),
                items: ['To Read', 'Reading', 'Completed']
                    .map((state) => DropdownMenuItem(value: state, child: Text(state,
                     style: Theme.of(context).textTheme.bodyLarge,)))
                    .toList(),
                onChanged: (value) => setState(() => selectedState = value!),
              ),

               SizedBox(height: screenHeight *0.02),
              Align(
                alignment: Alignment.centerLeft,
                child:GestureDetector(   //widget cliccabile in ogni suo punto 
                  onTap: _showImageSourceOptions,
                  child: _selectedImage != null
                      ? ClipRRect(   //se è stata selezionata un immagine : 
                          borderRadius: BorderRadius.circular(8), //angoli arrondati 
                          child: Image.file(
                            _selectedImage!,
                            height: 180,
                            width: screenWidth * 0.5,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Container(   //se non è stata selezionata un immagine
                          height:  screenHeight *0.15,
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

              SizedBox(height: screenHeight *0.02),

              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newBook = Book(
                      title: titleController.text,
                      author: authorController.text,
                      genre: selectedGenre,
                      plot: plotController.text,
                      imagePath:  _selectedImage?.path ?? 'assets/books/placeholder.jpg',
                      userState: selectedState,
                    );

                    await DatabaseHelper.instance.insertBook(newBook); // Aggiunta a lista dei libri dell utente

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

