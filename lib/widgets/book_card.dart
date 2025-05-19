import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/book_detail_page.dart';

class BookCard extends StatelessWidget {
  final Book book;

 const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 👇 Apri la pagina dettaglio passando il libro
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(book: book),
          ),
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            book.imagePath,
            height: 140,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}