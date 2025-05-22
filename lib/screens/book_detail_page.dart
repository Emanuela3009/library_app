import 'package:flutter/material.dart';
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
  String selectedState = '';
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final book = widget.book;
    selectedState = book.userState ?? 'To Read';
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


void _showAddBookDialog(BuildContext context) {
  final theme = Theme.of(context);
  Category? selectedCategory;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Choose Category',
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color.fromARGB(255, 30, 42, 120), // titolo in blu scuro
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return DropdownButtonFormField<Category>(
              value: selectedCategory,
              hint: Text(
                'Select a category',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color.fromARGB(221, 1, 30, 100),
                ),
              ),
              items: allCategories.map((cat) {
                return DropdownMenuItem<Category>(
                  value: cat,
                  child: Text(
                    cat.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color.fromARGB(221, 1, 30, 100),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(0, 1, 31, 100),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color:const Color.fromARGB(221, 1, 30, 100),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color:const Color.fromARGB(221, 1, 30, 100),
                    width: 1.5,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 22, 78, 199),
                    width: 2,
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color.fromARGB(255, 22, 78, 199),
              ),
            ),
          ),
         ElevatedButton(
          onPressed: () async {
            if (selectedCategory != null) {
              widget.book.categoryId = selectedCategory!.id;
              await DatabaseHelper.instance.insertBook(widget.book);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF1E2A78), // blu scuro
                content: Text(
                  'Book added to "${selectedCategory!.name}"',
                  style: const TextStyle(
                    color: Color(0xFF8FAADC), // azzurro chiaro
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,  //corsivo
                  ),
                ),
                behavior: SnackBarBehavior.floating, // opzionale: lo stacca dal fondo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 3),
              ),
            );

            }
          },
          child: const Text('Add'), // usa lo stile dal tema globale, come "Create"
        ),

        ],
      );
    },
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
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05; // 5% della larghezza
    final screenHeight = MediaQuery.of(context).size.height;
     
  
    
  return WillPopScope(
    onWillPop: () async {
      // Salva i dati prima di uscire
      book.comment = commentController.text;
      book.rating = rating;
      book.userState = selectedState;
      return true; // consenti l'uscita
    },
    child: Scaffold(
      appBar: AppBar(
        actions: [     //per tornare alla pagina precedente
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
                book.comment = commentController.text;
                book.rating = rating;
                book.userState = selectedState;
                Navigator.pop(context);
              },
          )
        ],
      ),
      
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: ListView(
          children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    book.imagePath,
                    height: screenHeight * 0.4,
                    fit: BoxFit.cover,
                  ),
                ),
             
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Column(
                children: [
                  Text(book.title, style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: const Color.fromARGB(221, 1, 30, 100),
                  )),
                  const SizedBox(height: 4),
                  Text(book.author, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              book.plot,
              style:  Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(103, 25, 64, 156),
              ),
                textAlign: TextAlign.justify,
            ),
            SizedBox(height: screenHeight * 0.03),
              Text("Your Review",
                style: Theme.of(context).textTheme.titleMedium),
             SizedBox(height: screenHeight * 0.002),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                );
              }),
            ),

            SizedBox(height: screenHeight * 0.02),

            TextField(
            controller: commentController,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color.fromARGB(255, 106, 147, 221),
            ),
            decoration: InputDecoration(
              hintText: 'Leave a comment',
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color.fromARGB(255, 106, 147, 221),
              ),
              filled: true,
              fillColor:const Color.fromARGB(0, 106, 146, 221),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: const Color.fromARGB(255, 106, 147, 221),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 106, 147, 221),
                  width: 1.5,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 22, 78, 199),  //quando premo il bordo è più scuro
                  width: 2,
                ),
              ),
            ),
            maxLines: 1,
          ),


            SizedBox(height: screenHeight * 0.01),

            DropdownButtonFormField(
            value: selectedState,
            items: ['To Read', 'Reading', 'Completed']
                .map((state) => DropdownMenuItem(
                      value: state,
                      child: Text(
                        state,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color.fromARGB(255, 106, 147, 221),  // stesso colore di Your Review
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedState = value!;
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(0, 1, 31, 100), // box con sfondo trasparente
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: const Color.fromARGB(255, 106, 147, 221),  // bordo dello stesso colore del testo all'interno
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color:const Color.fromARGB(255, 106, 147, 221), 
                  width: 1.5,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 22, 78, 199), // leggermente più vivo quando lo si preme
                  width: 2,
               ),
              ),
            ),
          ),

            SizedBox(height: screenHeight * 0.02),

            ElevatedButton.icon(
              onPressed: () => _showAddBookDialog(context),
              icon: const Icon(Icons.add),
              label: const Text("Add Book"),
            ),
          ],
        ),
      ),
    ),
  );
  }
}