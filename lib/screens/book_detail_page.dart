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
          title:  Text('Choose category'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButtonFormField<Category>(
                value: selectedCategory,
                hint:  Text('Select a category',
                style: theme.textTheme.bodyLarge),
                items: allCategories.map((cat) {
                  return DropdownMenuItem<Category>(
                    value: cat,
                    child: Text(cat.name,
                    style: Theme.of(context).textTheme.bodyLarge,),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedCategory != null) {
                  widget.book.categoryId = selectedCategory!.id;
                  await DatabaseHelper.instance.insertBook(widget.book);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Book added to "${selectedCategory!.name}"')),
                  );
                }
              },
              child: const Text('Add'),
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
                  Text(book.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(book.author, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              book.plot,
              style:  Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
            ),
            SizedBox(height: screenHeight * 0.02),
              Text("Your review",
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
              decoration: InputDecoration(
                hintText: 'Leave a comment',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 1,
            ),

             SizedBox(height: screenHeight * 0.01),

            DropdownButtonFormField(
              value: selectedState,
              items: ['To Read', 'Reading', 'Completed']
                  .map((state) =>
                      DropdownMenuItem(value: state, child: 
                            Text(state,style: Theme.of(context).textTheme.bodyLarge )))
                  .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedState = value!;
                    });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            ElevatedButton.icon(
              onPressed: () => _showAddBookDialog(context),
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