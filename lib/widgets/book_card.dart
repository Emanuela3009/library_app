import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/book_detail_page.dart';
import '../data/database_helper.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onUpdate;

  const BookCard({super.key, required this.book, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(book: book),
          ),
        );
        if (onUpdate != null) onUpdate!();
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 3 / 4.5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      book.imagePath,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                    top: 6,
                    right: 6,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        book.isFavorite = !book.isFavorite;
                        await DatabaseHelper.instance.insertBook(book);
                        if (onUpdate != null) onUpdate!();
                      },
                      child: Icon(  //cuore cliccabile
                        book.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: book.isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              book.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}