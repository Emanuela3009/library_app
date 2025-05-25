import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import '../widgets/book_card.dart';
import 'library_page.dart';
import 'favorites_page.dart';
import 'Home_page.dart';
import 'popular_page.dart';

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
          readingBooks.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6), // Spazio sotto il titolo
                    const Text("No books available"),
                    const SizedBox(height: 16),
                  ],
                ),
                )
            : SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: readingBooks.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) => BookCard(
                    book: readingBooks[index],
                    onUpdate: _loadBooksFromDatabase,
                  ),
                ),
              ),

          // Popular Now + freccetta ravvicinata alla scritta
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Popular now",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 6), // distanza minima tra testo e freccia
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PopularPage()),
                    );
                  },
                  child: const Icon(Icons.arrow_forward_ios, size: 14),
                ),
              ],
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

          // Your Favorites + freccetta ravvicinata che cambia tab della nav bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your favorites",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    final homeState =
                        context.findAncestorStateOfType<HomePageState>();
                    if (homeState != null) {
                      homeState.setIndex(3); // Vai alla scheda "Favorites"
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios, size: 14),
                ),
              ],
            ),
          ),
          favoriteBooks.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6), // Spazio sotto il titolo
                    const Text("No favorites yet"),
                    const SizedBox(height: 16), // Spazio extra prima della sezione successiva
                  ],
                ),
              )
            : SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: favoriteBooks.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) => BookCard(
                    book: favoriteBooks[index],
                    onUpdate: _loadBooksFromDatabase,
                  ),
                ),
              ),

          // Your Books + freccetta vicina
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your books",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LibraryPage()),
                    );
                  },
                  child: const Icon(Icons.arrow_forward_ios, size: 14),
                ),
              ],
            ),
          ),
          userBooks.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6), // Spazio sotto il titolo
                    const Text("No books added yet"),
                    const SizedBox(height: 16), // Spazio extra prima della sezione successiva
                  ],
                ),
              )
            : SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userBooks.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) => BookCard(
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
