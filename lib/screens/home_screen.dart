import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


@override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  List<Book> allBooks = [];
  
  @override
  void initState() {
    super.initState();
    _loadBooksFromDatabase();
  }

  Future<void> _loadBooksFromDatabase() async {
    final books = await DatabaseHelper.instance.getAllBooks();
    setState(() {
      allBooks = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    final readingBooks = allBooks.where((b) => b.userState == 'Reading').toList();
    final popularBooks = allBooks.take(3).toList();
    final userBooks = allBooks.where((b) => b.isUserBook == true).toList();

    return SingleChildScrollView(
      child: Column(     //allina verticalmente 
        crossAxisAlignment: CrossAxisAlignment.start,  //allinea a sinistra 
        children: [

          //Currently Reading
          Padding(
            padding: const EdgeInsets.all(16),   //inserisce padding all interno del widget 
            child: Text("Currently reading", style: Theme.of(context).textTheme.titleMedium),
          ),
          
          SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: readingBooks.length, // o una lista "readingBooks"
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) => BookCard(
              book: readingBooks[index],
              onUpdate: _loadBooksFromDatabase, // callback passata
            ),
          ),
        ),
          
         

          //Popular Now
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Popular now", style: Theme.of(context).textTheme.titleMedium),
          ),
          SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularBooks.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
           itemBuilder: (context, index) => BookCard(
            book: popularBooks[index],
            onUpdate: _loadBooksFromDatabase, // AGGIUNTO!
          ),
          ),
        ),


          //Your Books
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Your books", style: Theme.of(context).textTheme.titleMedium),
          ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: userBooks.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
           itemBuilder: (context, index) => BookCard(
            book: userBooks[index],
            onUpdate: _loadBooksFromDatabase, // AGGIUNTO!
          ),
            ),
        ),
        ],
      ),
    );
  }
}
