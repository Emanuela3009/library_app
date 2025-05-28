import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';
import '../data/database_helper.dart';

class BookGridCard extends StatefulWidget {
  final Book book;
  final VoidCallback? onFavoriteToggle;

  const BookGridCard({super.key, required this.book, this.onFavoriteToggle});

  @override
  State<BookGridCard> createState() => _BookGridCardState();
}

class _BookGridCardState extends State<BookGridCard> {
  String? _fullImagePath;
  bool? _fileExists;

  @override
  void initState() {
    super.initState();
    _resolveImagePath();
  }

  Future<void> _resolveImagePath() async {
    if (widget.book.imagePath.startsWith('assets/')) {
      setState(() {
        _fullImagePath = null;
        _fileExists = null; // è asset
      });
      return;
    }

    String path = widget.book.imagePath;
    if (path.startsWith('/private/')) {
      path = path.replaceFirst('/private', '');
    }
    final dir = await getApplicationDocumentsDirectory();

    // Se il path è già completo
    if (path.startsWith(dir.path)) {
      _fullImagePath = path;
    } else {
      _fullImagePath = '${dir.path}/${path.split('/').last}';
    }

    final file = File(_fullImagePath!);
    final exists = await file.exists();

    setState(() {
      _fileExists = exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget imageWidget;

    if (_fileExists == null) {
      // asset image
      imageWidget = Image.asset(
        widget.book.imagePath,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      );
    } else if (_fileExists == true && _fullImagePath != null) {
      imageWidget = Image.file(
        File(_fullImagePath!),
        fit: BoxFit.contain,
        alignment: Alignment.center,
      );
    } else {
      imageWidget = Image.asset(
        'assets/books/placeholder.jpg',
        fit: BoxFit.contain,
        alignment: Alignment.center,
      );
    }

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
                      // Aggiorna DB
                      await DatabaseHelper.instance.insertBook(widget.book);
                      // Aggiorna UI in pagina (callback)
                      if (widget.onFavoriteToggle != null) {
                        widget.onFavoriteToggle!();
                      }
                      setState(() {}); // per aggiornare icona
                    },
                    child: Icon(
                      widget.book.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.book.isFavorite ? Colors.pink : Colors.grey,
                      size: screenWidth * 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            widget.book.title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.book.author.trim().isNotEmpty)
          Text(
            widget.book.author,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),    
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
  }
}