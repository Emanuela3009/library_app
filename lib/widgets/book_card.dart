import 'dart:io';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/book_detail_page.dart';
import '../data/database_helper.dart';

/* Widget che rappresenta una card verticale per mostrare un libro.
   Include immagine, titolo, icona per i preferiti e navigazione al dettaglio. */
class BookCard extends StatefulWidget {
  final Book book; // Dati del libro da visualizzare
  final VoidCallback? onUpdate; // Callback per aggiornare la lista chiamante

  const BookCard({super.key, required this.book, this.onUpdate});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool? _fileExists;
  String? _fullImagePath;

  // Controlla se esiste un file immagine personalizzato per il libro.
  @override
  void initState() {
    super.initState();
    _checkFileExists();
  }

  // Verifica la presenza fisica dell'immagine locale del libro.
  Future<void> _checkFileExists() async {
    final path = await widget.book.getImageFullPath();

    if (path == null) {
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

  /* Costruisce la UI della card libro, con immagine, titolo e cuore.
     Gestisce il tap per navigare alla BookDetailPage e aggiornare il libro. */
  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_fileExists == null) {
      imageWidget = Image.asset(widget.book.imagePath, fit: BoxFit.cover);
    } else if (_fileExists == true && _fullImagePath != null) {
      imageWidget = Image.file(
        File(_fullImagePath!),
        fit: BoxFit.cover,
        key: UniqueKey(),
      );
    } else {
      imageWidget = Image.asset(
        'assets/books/placeholder.jpg',
        fit: BoxFit.cover,
      );
    }

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(book: widget.book),
          ),
        );
        if (result == true) {
          await _checkFileExists();
          if (widget.onUpdate != null) widget.onUpdate!();
        }
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Immagine con bordo arrotondato e cuore in alto a destra
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
                          await _checkFileExists();
                        },
                        child: Icon(
                          widget.book.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              widget.book.isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Titolo del libro (massimo 2 righe)
            SizedBox(
              height: 36,
              child: Text(
                widget.book.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
