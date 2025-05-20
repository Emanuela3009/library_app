import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/fake_books.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


@override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(     //allina verticalmente 
        crossAxisAlignment: CrossAxisAlignment.start,  //allinea a sinistra 
        children: [

          //sezione 1
          Padding(
            padding: const EdgeInsets.all(16),   //inserisce padding all interno del widget 
            child: Text("Currently reading", style: Theme.of(context).textTheme.titleLarge),
          ),
          
          SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: readingBooks.length, // o una lista "readingBooks"
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) => BookCard(book: readingBooks[index]),
          ),
        ),
          
           // magari un ListView orizzontalev

          //sezione 2
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Popular now", style: Theme.of(context).textTheme.titleLarge),
          ),
          SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularBooks.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) => BookCard(book: popularBooks[index]),
          ),
        ),


          //sezione 3
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Your books", style: Theme.of(context).textTheme.titleLarge),
          ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: userBooks.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) => BookCard(book: userBooks[index]),
          ),
        ),
        ],
      ),
    );
  }
}
