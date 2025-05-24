import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import '../widgets/book_card.dart';
import 'library_page.dart';
import 'favorites_page.dart';

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
    final readingBooks =
        allBooks.where((b) => b.userState == 'Reading').toList();
    final popularBooks = allBooks.take(3).toList();
    final userBooks = allBooks.where((b) => b.isUserBook == true).toList();
    final favoriteBooks = allBooks.where((b) => b.isFavorite).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Currently Reading
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Currently reading",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: readingBooks.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder:
                  (context, index) => BookCard(
                    book: readingBooks[index],
                    onUpdate: _loadBooksFromDatabase,
                  ),
            ),
          ),

          // Popular Now
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Popular now",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularBooks.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder:
                  (context, index) => BookCard(
                    book: popularBooks[index],
                    onUpdate: _loadBooksFromDatabase,
                  ),
            ),
          ),

          // Your Favorites + freccetta
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Your favorites",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FavoritesPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Your Books + freccetta
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Your books",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LibraryPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: userBooks.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder:
                  (context, index) => BookCard(
                    book: userBooks[index],
                    onUpdate: _loadBooksFromDatabase,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
