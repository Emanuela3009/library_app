import 'dart:io';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import 'book_detail_page.dart';

/*
 * Pagina di ricerca avanzata con filtri e ordinamento.
 * Permette di cercare i libri per titolo o autore,
 * e filtrare per stato, genere e valutazione.
*/
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];

  String? _searchType = 'All';
  String? _selectedStatus;
  String? _selectedGenre;
  int _selectedRating = -1;

  // Inizializza lo stato e carica i libri dal database.
  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  // Carica tutti i libri dal database locale e applica i filtri correnti.
  Future<void> _loadBooks() async {
    final books = await DatabaseHelper.instance.getAllBooks();
    setState(() {
      _allBooks = books;
    });
    _filterBooks(_searchController.text);
  }

  // Applica i filtri di ricerca: testo, stato, genere, rating, ordinamento.
  void _filterBooks(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      List<Book> filtered = _allBooks;

      // Ricerca con ranking basato su corrispondenza parziale del titolo/autore
      if (lowerQuery.trim().isNotEmpty) {
      List<MapEntry<Book, int>> rankedBooks = [];
      final String query = lowerQuery.trim();

      for (var book in _allBooks) {
        final String title = book.title.toLowerCase().trim();
        final String author = book.author.toLowerCase().trim();

        int? matchRank;

        // Caso 1: la query è una frase (contiene almeno uno spazio)
        if (query.contains(' ')) {
          int titleIndex = title.indexOf(query);
          if (titleIndex != -1) {
            matchRank = titleIndex;
          } else {
            int authorIndex = author.indexOf(query);
            if (authorIndex != -1) {
              matchRank = 1000 + authorIndex;
            }
          }
        } 
        // Caso 2: la query è una parola singola → match per parola iniziale
        else {
          final titleWords = title.split(' ');
          for (int i = 0; i < titleWords.length; i++) {
            if (titleWords[i].startsWith(query)) {
              matchRank = i;
              break;
            }
          }

          if (matchRank == null) {
            final authorWords = author.split(' ');
            for (int i = 0; i < authorWords.length; i++) {
              if (authorWords[i].startsWith(query)) {
                matchRank = 1000 + i;
                break;
              }
            }
          }
        }

        if (matchRank != null) {
          rankedBooks.add(MapEntry(book, matchRank));
        }
      }

      // Ordina i risultati in base alla priorità
      rankedBooks.sort((a, b) => a.value.compareTo(b.value));
      filtered = rankedBooks.map((e) => e.key).toList();
    }


      // Applica i filtri aggiuntivi
      if (_selectedStatus != null && _selectedStatus != 'All') {
        filtered =
            filtered.where((b) => b.userState == _selectedStatus).toList();
      }
      if (_selectedGenre != null && _selectedGenre != 'All') {
        filtered = filtered.where((b) => b.genre == _selectedGenre).toList();
      }
      if (_selectedRating != -1) {
        filtered = filtered.where((b) => b.rating == _selectedRating).toList();
      }

      // Reset se non c’è alcun filtro attivo
      if (lowerQuery.isEmpty &&
          (_selectedStatus == null || _selectedStatus == 'All') &&
          (_selectedGenre == null || _selectedGenre == 'All') &&
          _selectedRating == -1) {
        filtered = _allBooks;
      }

      // Ordinamento A-Z o Z-A
      if (_searchType == 'A-Z') {
        filtered.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      } else if (_searchType == 'Z-A') {
        filtered.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
      }

      _filteredBooks = filtered;
    });
  }

  // Pulisce il campo di ricerca e rimuove i filtri testuali.
  void _clearSearch() {
    _searchController.clear();
    _filterBooks('');
  }

  // Costruisce l’interfaccia della schermata di ricerca,
  // con filtri, dropdown, risultati e gestione dei preferiti.
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.015,
        ),
        child: Column(
          children: [
            // Campo di ricerca
            TextField(
              controller: _searchController,
              onChanged: _filterBooks,
              decoration: InputDecoration(
                hintText: 'Search by title or author',
                hintStyle: const TextStyle(color: Color(0xFF7C7C7C)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF000000)),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Color(0xFF000000),
                          ),
                          onPressed: _clearSearch,
                        )
                        : null,
                filled: true,
                fillColor: const Color.fromARGB(20, 0, 0, 0),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF000000)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF000000), width: 1.5),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF000000), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown per filtri e ordinamento
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: "Ordered by",
                        value: _searchType,
                        items: ['All', 'Title', 'Author', 'A-Z', 'Z-A'],
                        onChanged: (val) {
                          _searchType = val!;
                          _filterBooks(_searchController.text);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdown(
                        label: "State",
                        value: _selectedStatus,
                        items: ['All', 'To Read', 'Reading', 'Completed'],
                        onChanged: (val) {
                          _selectedStatus = val!;
                          _filterBooks(_searchController.text);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: "Genre",
                        value: _selectedGenre,
                        items: [
                          'All',
                          'Fantasy',
                          'Romance',
                          'Adventure',
                          'Sci-Fi',
                          'Horror',
                        ],
                        onChanged: (val) {
                          _selectedGenre = val!;
                          _filterBooks(_searchController.text);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedRating == -1 ? null : _selectedRating,
                        decoration: _inputDecoration("Rate"),
                        iconEnabledColor: const Color(0xFF000000),
                        style: const TextStyle(color: Color(0xFF000000)),
                        onChanged: (val) {
                          _selectedRating = val ?? -1;
                          _filterBooks(_searchController.text);
                        },
                        items: [
                          const DropdownMenuItem(value: -1, child: Text("All")),
                          ...List.generate(5, (i) {
                            final rating = i + 1;
                            return DropdownMenuItem(
                              value: rating,
                              child: Row(
                                children: List.generate(
                                  rating,
                                  (_) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Titolo della sezione risultati
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _searchController.text.isEmpty ? 'Recommended' : 'Results',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ),

            // Lista risultati o messaggio se vuota
            _filteredBooks.isEmpty
                ? const Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(color: Color(0xFF7C7C7C)),
                  ),
                )
                : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _filteredBooks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final book = _filteredBooks[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailPage(book: book),
                          ),
                        );
                        _loadBooks();
                      },
                      child: _buildBookCard(book),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }

  /// Costruisce il widget di una singola card libro con immagine e info.
  Widget _buildBookCard(Book book) {
    return Container(
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
      child: Row(
        children: [
          // Immagine libro + cuore
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FutureBuilder<String?>(
                  future: book.getImageFullPath(),
                  builder: (context, snapshot) {
                    final double imageHeight = 130;
                    final double imageWidth = 90;
                    Widget imageWidget;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      imageWidget = Container(
                        height: imageHeight,
                        width: imageWidth,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ),
                      );
                    } else {
                      final path = snapshot.data;
                      if (path != null && File(path).existsSync()) {
                        imageWidget = Image.file(
                          File(path),
                          height: imageHeight,
                          width: imageWidth,
                          fit: BoxFit.cover,
                        );
                      } else if (book.imagePath.startsWith('assets/')) {
                        imageWidget = Image.asset(
                          book.imagePath,
                          height: imageHeight,
                          width: imageWidth,
                          fit: BoxFit.cover,
                        );
                      } else {
                        imageWidget = Image.asset(
                          'assets/books/placeholder.jpg',
                          height: imageHeight,
                          width: imageWidth,
                          fit: BoxFit.cover,
                        );
                      }
                    }

                    return imageWidget;
                  },
                ),
              ),
              // Icona preferito
              Positioned(
                top: 6,
                right: 6,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () async {
                      setState(() {
                        book.isFavorite = !book.isFavorite;
                      });
                      await DatabaseHelper.instance.insertBook(book);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        book.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: book.isFavorite ? Colors.pink : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Info libro
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: const TextStyle(color: Color(0xFF7C7C7C)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < (book.rating ?? 0) ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Crea un dropdown stilizzato per i filtri.
  DropdownButtonFormField<String> _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(label),
      iconEnabledColor: const Color(0xFF000000),
      style: const TextStyle(color: Color(0xFF000000)),
      onChanged: onChanged,
      items:
          items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
    );
  }

  /// Restituisce lo stile per i campi dei dropdown.
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      label: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF7C7C7C),
          fontWeight: FontWeight.w500,
        ),
      ),
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF000000), width: 1.5),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF000000), width: 2),
      ),
    );
  }
}
