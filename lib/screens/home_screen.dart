import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import '../widgets/book_card.dart';
import 'library_page.dart';
import 'popular_page.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChanged;
  const HomeScreen({super.key, required this.onTabChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<Book> allBooks = [];
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadBooksFromDatabase();
    }
  }
  @override
  void initState() {
    super.initState();
    _loadBooksFromDatabase();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadBooksFromDatabase() async {
  final books = await DatabaseHelper.instance.getAllBooks();
  if (!mounted) return;
  setState(() {
    allBooks = books;
  });
}


@override
void didChangeDependencies() {
  super.didChangeDependencies();
  ModalRoute.of(context)?.addScopedWillPopCallback(() async {
    await _loadBooksFromDatabase();
    return true;
  });
}

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final horizontalPadding = screen.width * 0.04;
    final readingBooks = allBooks.where((b) => b.userState == 'Reading').toList();
    final popularBooks = allBooks.where((b) => !b.isUserBook).take(9).toList();
    final userBooks = allBooks.where((b) => b.isUserBook == true).toList()..sort((a, b) => b.id!.compareTo(a.id!));
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

    Widget buildBookList(List<Book> books) {
      final isLandscape = screen.width > screen.height;
      final isTablet = screen.shortestSide >= 600;

      final cardWidth = isTablet
          ? (isLandscape ? screen.width * 0.18 : screen.width * 0.22)
          : (isLandscape ? screen.width * 0.2 : screen.width * 0.35);

      final coverAspectRatio = 3 / 4.5;
      final imageHeight = cardWidth / coverAspectRatio;
      final cardHeight = imageHeight + (isTablet ? 65 : 60);

      return SizedBox(
        height: cardHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: books.length,
          padding: EdgeInsets.symmetric(horizontal: screen.width * 0.04),
          itemBuilder: (context, index) => SizedBox(
            width: cardWidth,
            child: BookCard(
              key: ValueKey(books[index].id.toString() + (books[index].imagePath ?? '')),
              book: books[index],
              onUpdate: _loadBooksFromDatabase,
            ),
          ),
          separatorBuilder: (_, __) => SizedBox(width: screen.width * 0.02),
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
        return Scrollbar(
          thumbVisibility: true,
          thickness: 4,
          radius: const Radius.circular(8),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                        : buildBookList(readingBooks),

                    buildSectionTitle("Popular now", () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PopularPage()));
                    }),
                    buildBookList(popularBooks,),
                    buildSectionTitle("Your favorites", () {
                      widget.onTabChanged(3);

                    }),
                    favoriteBooks.isEmpty
                        ? buildEmptyText("No favorites yet")
                        : buildBookList(favoriteBooks,),

                    buildSectionTitle("Your books", () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LibraryPage()))
                      .then((_) => _loadBooksFromDatabase());
                    }),
                    userBooks.isEmpty
                        ? buildEmptyText("No books added yet")

                        : buildBookList(userBooks,),

                    SizedBox(height: screen.height * 0.05),

                  ],
                ),
              ),
            ),
          ),
        );
        },
      ),
    );
  }
}
