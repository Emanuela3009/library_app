import 'package:flutter/material.dart';
import '../models/book.dart';


class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                book.imagePath,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text("📖 Titolo", style: Theme.of(context).textTheme.titleMedium),
            Text(book.title, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Text("👩‍💼 Autore", style: Theme.of(context).textTheme.titleMedium),
            Text(book.author),
            const SizedBox(height: 12),
            Text("📚 Genere", style: Theme.of(context).textTheme.titleMedium),
            Text(book.genre),
            const SizedBox(height: 12),
            Text("📌 Stato", style: Theme.of(context).textTheme.titleMedium),
            Text(book.state),
            const SizedBox(height: 12),
            Text("📝 Trama", style: Theme.of(context).textTheme.titleMedium),
            Text(book.plot),
          ],
        ),
      ),
    );
  }
}