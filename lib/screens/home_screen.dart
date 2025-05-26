import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import '../widgets/book_card.dart';
import 'library_page.dart';
import 'Home_page.dart';
import 'popular_page.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChanged;
  const HomeScreen({super.key, required this.onTabChanged});

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

    final screen = MediaQuery.of(context).size;
    final sectionHeight = screen.height * 0.23;
    final horizontalPadding = screen.width * 0.03;
    final readingBooks = allBooks.where((b) => b.userState == 'Reading').toList();
   final popularBooks = allBooks.where((b) => !b.isUserBook).take(9).toList();
    final userBooks = allBooks.where((b) => b.isUserBook == true).toList();
    final favoriteBooks = allBooks.where((b) => b.isFavorite).toList();

    Widget buildSectionTitle(String title, VoidCallback? onTap) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: screen.height * 0.015),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(width: screen.width * 0.01),
            if (onTap != null)
              GestureDetector(
                onTap: onTap,
                child: Icon(Icons.arrow_forward_ios, size: screen.width * 0.035),
              ),
          ],
        ),
      );
    }

    Widget buildBookList(List<Book> books, double height) {
      return SizedBox(
        height: height + 30,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: books.length,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          itemBuilder: (context, index) => BookCard(
            book: books[index],
            onUpdate: _loadBooksFromDatabase,
          ),
        ),
      );
    }

    Widget buildEmptyText(String text) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screen.height * 0.008),
            Text(text),
            SizedBox(height: screen.height * 0.05),
          ],
        ),
      );
    }

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionTitle("Currently reading", null),
                    readingBooks.isEmpty
                        ? buildEmptyText("No books available")
                        : buildBookList(readingBooks, sectionHeight),

                    buildSectionTitle("Popular now", () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PopularPage()));
                    }),
                    buildBookList(popularBooks, sectionHeight),

                    buildSectionTitle("Your favorites", () {
                     // final homeState = context.findAncestorStateOfType<HomePageState>();
                      //homeState?.setIndex(3);
                      widget.onTabChanged(3);

                    }),
                    favoriteBooks.isEmpty
                        ? buildEmptyText("No favorites yet")
                        : buildBookList(favoriteBooks, sectionHeight),

                    buildSectionTitle("Your books", () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LibraryPage()));
                    }),
                    userBooks.isEmpty
                        ? buildEmptyText("No books added yet")
                        : buildBookList(userBooks, sectionHeight),

                    // aggiungi uno spazio finale
                    SizedBox(height: screen.height * 0.05),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
