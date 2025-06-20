import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';
import '../data/database_helper.dart';

/// Card da usare in una griglia per visualizzare un libro.
/// Mostra immagine, titolo, autore, rating e stato di lettura.
/// Gestisce anche il toggle dei preferiti.
class BookGridCard extends StatefulWidget {
  final Book book; // Dati del libro
  final VoidCallback? onFavoriteToggle; // Callback al cambio di stato preferito

  const BookGridCard({super.key, required this.book, this.onFavoriteToggle});

  @override
  State<BookGridCard> createState() => _BookGridCardState();
}

class _BookGridCardState extends State<BookGridCard> {
  String? _fullImagePath;
  bool? _fileExists;

  /// Inizializza e risolve il percorso dell’immagine locale del libro.
  @override
  void initState() {
    super.initState();
    _resolveImagePath();
  }

  /// Controlla se l'immagine è cambiata rispetto al widget precedente.
  @override
  void didUpdateWidget(covariant BookGridCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.book.imagePath != widget.book.imagePath) {
      _resolveImagePath();
    }
  }

  /// Verifica se esiste l’immagine salvata localmente e ne determina il path assoluto.
  Future<void> _resolveImagePath() async {
    if (widget.book.imagePath.startsWith('assets/')) {
      setState(() {
        _fullImagePath = null;
        _fileExists = null;
      });
      return;
    }

    String path = widget.book.imagePath;
    if (path.startsWith('/private/')) {
      path = path.replaceFirst('/private', '');
    }

    final dir = await getApplicationDocumentsDirectory();
    if (path.startsWith(dir.path)) {
      _fullImagePath = path;
    } else {
      _fullImagePath = '${dir.path}/${path.split('/').last}';
    }

    final file = File(_fullImagePath!);
    final exists = await file.exists();

    if (exists) {
      // Svuota la cache per assicurarsi che l'immagine venga aggiornata
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    }

    setState(() {
      _fileExists = exists;
    });
  }

  /// Costruisce la card del libro con immagine, cuore preferiti, titolo, autore, rating e stato.
  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // Determina quale immagine mostrare in base allo stato del file
    if (_fileExists == null) {
      imageWidget = Image.asset(
        widget.book.imagePath,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      );
    } else if (_fileExists == true && _fullImagePath != null) {
      imageWidget = Image.file(
        File(_fullImagePath!),
        key: UniqueKey(),
        fit: BoxFit.contain,
        alignment: Alignment.center,
        gaplessPlayback: false,
      );
    } else {
      imageWidget = Image.asset(
        'assets/books/placeholder.jpg',
        fit: BoxFit.contain,
        alignment: Alignment.center,
      );
    }

    // Layout responsivo della card
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.of(context).size;
        final screenWidth = screenSize.width;

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Immagine + cuore preferito
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox.expand(child: imageWidget),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          widget.book.isFavorite = !widget.book.isFavorite;
                          await DatabaseHelper.instance.insertBook(widget.book);
                          if (widget.onFavoriteToggle != null) {
                            widget.onFavoriteToggle!();
                          }
                          setState(() {});
                        },
                        child: Icon(
                          widget.book.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              widget.book.isFavorite
                                  ? Colors.pink
                                  : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenWidth * 0.02),

              // Titolo
              Text(
                widget.book.title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Autore
              if (widget.book.author.trim().isNotEmpty)
                Text(
                  widget.book.author,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

              // Rating
              Text(
                '⭐ ${widget.book.rating ?? 0}/5',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth < 500 ? 13 : 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Stato di lettura (To Read, Reading, Completed)
              if ((widget.book.userState ?? '').trim().isNotEmpty)
                Text(
                  widget.book.userState!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black87,
                    fontSize: screenWidth < 500 ? 13 : 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        );
      },
    );
  }
}
