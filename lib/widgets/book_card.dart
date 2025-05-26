import 'dart:io';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/book_detail_page.dart';
import '../data/database_helper.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final VoidCallback? onUpdate;

  const BookCard({super.key, required this.book, this.onUpdate});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool? _fileExists;
  String? _fullImagePath;

  @override
  void initState() {
    super.initState();
    _checkFileExists();
  }

  Future<void> _checkFileExists() async {
    final path = await widget.book.getImageFullPath();

    if (path == null) {
      // immagine da asset
      setState(() {
        _fileExists = null;
        _fullImagePath = null;
      });
      return;
    }

    final file = File(path);
    final exists = await file.exists();

    setState(() {
      _fileExists = exists;
      _fullImagePath = exists ? path : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_fileExists == null) {
      // immagine asset
      imageWidget = Image.asset(widget.book.imagePath, fit: BoxFit.cover);
    } else if (_fileExists == true && _fullImagePath != null) {
      imageWidget = Image.file(File(_fullImagePath!), fit: BoxFit.cover);
    } else {
      // file non trovato, mostra placeholder
      imageWidget = Image.asset('assets/books/placeholder.jpg', fit: BoxFit.cover);
    }

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetailPage(book: widget.book)),
        );
        if (widget.onUpdate != null) widget.onUpdate!();
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
                    imageWidget,
                    Positioned(
                      top: 6,
                      right: 6,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          widget.book.isFavorite = !widget.book.isFavorite;
                          await DatabaseHelper.instance.insertBook(widget.book);
                          if (widget.onUpdate != null) widget.onUpdate!();
                        },
                        child: Icon(
                          widget.book.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: widget.book.isFavorite ? Colors.red : Colors.grey,
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
              widget.book.title,
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