// IMPORT
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import 'book_detail_page.dart';

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

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
  final books = await DatabaseHelper.instance.getAllBooks();
  setState(() {
    _allBooks = books;
  });

  // Applica subito i filtri per popolare _filteredBooks correttamente
  _filterBooks(_searchController.text);
}


  void _filterBooks(String query) {
  final lowerQuery = query.toLowerCase();

  setState(() {
    List<Book> filtered = _allBooks;

    // Se c'è una query, filtra per titolo/autore
    if (lowerQuery.isNotEmpty) {
      filtered = filtered.where((book) {
      final titleWords = book.title.toLowerCase().split(' ');
      final authorWords = book.author.toLowerCase().split(' ');
      final queryWords = lowerQuery.split(' ');

      bool startsWithOrdered(List<String> sourceWords, List<String> queryWords) {
        if (queryWords.length > sourceWords.length) return false;

        for (int i = 0; i < queryWords.length; i++) {
          if (!sourceWords[i].startsWith(queryWords[i])) {
            return false;
          }
        }
        return true;
      }

      final titleMatch = startsWithOrdered(titleWords, queryWords);
      final authorMatch = startsWithOrdered(authorWords, queryWords);

      switch (_searchType) {
        case 'Title':
          return titleMatch;
        case 'Author':
          return authorMatch;
        case 'All':
        default:
          return titleMatch || authorMatch;
      }
    }).toList();
    }

    // Applica i filtri (se presenti)
    if (_selectedStatus != null && _selectedStatus != 'All') {
      filtered = filtered.where((b) => b.userState == _selectedStatus).toList();
    }

    if (_selectedGenre != null && _selectedGenre != 'All') {
      filtered = filtered.where((b) => b.genre == _selectedGenre).toList();
    }

    if (_selectedRating != -1) {
      filtered = filtered.where((b) => b.rating == _selectedRating).toList();
    }

    // Se non c'è query e nessun filtro → mostra tutti i libri (oredered by è impostato di default su 'all')
    if (lowerQuery.isEmpty &&
        (_selectedStatus == null || _selectedStatus == 'All') &&
        (_selectedGenre == null || _selectedGenre == 'All') &&
        _selectedRating == -1) {
      filtered = _allBooks;
    }

    _filteredBooks = filtered;
  });
}


  void _clearSearch() {
    _searchController.clear();
    _filterBooks('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Books", style: theme.textTheme.headlineLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo ricerca
            TextField(
              controller: _searchController,
              onChanged: _filterBooks,
              decoration: InputDecoration(
                hintText: 'Search by title or author',
                prefixIcon: IconButton(
                icon: const Icon(Icons.search, color: Color(0xFF1E2A78)),
                onPressed: () {
                  FocusScope.of(context).unfocus(); // Nasconde la tastiera
                  _filterBooks(_searchController.text);
                },
              ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: _clearSearch,
                      )
                    : null,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color.fromARGB(180, 1, 30, 100),
                ),
                filled: true,
                fillColor: const Color.fromARGB(25, 4, 36, 109),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6A93DD)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6A93DD), width: 1.5),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF164EC7), width: 2),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // FILTRI
            Column(
              children: [
                Row(
                  children: [

                    //ricerca per tipo
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _searchType,
                        decoration: const InputDecoration(
                          label: Text(
                          "Ordered by",
                          style: TextStyle(
                            color: Color.fromARGB(180, 1, 30, 100),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(180, 1, 30, 100),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(180, 1, 30, 100),
                            width: 2,
                          ),
                        ),
                        ),
                        iconEnabledColor: Theme.of(context).textTheme.bodyMedium?.color,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (val) {
                          setState(() {
                            _searchType = val!;
                            _filterBooks(_searchController.text);
                          });
                        },
                        items: ['All', 'Title', 'Author', 'A-Z', 'Z-A']
                            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 12),

                    //ricerca per stato
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          label: Text(
                          "State",
                          style: TextStyle(
                            color: Color.fromARGB(180, 1, 30, 100),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(180, 1, 30, 100),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(180, 1, 30, 100),
                            width: 2,
                          ),
                        ),
                        ),
                        iconEnabledColor: Theme.of(context).textTheme.bodyMedium?.color,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (val) {
                          setState(() {
                            _selectedStatus = val!;
                            _filterBooks(_searchController.text);
                          });
                        },
                        items: ['All', 'To Read', 'Reading', 'Completed']
                            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [

                    //ricerca per genere
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGenre,
                        decoration: const InputDecoration(
                          label: Text(
                          "Genre",
                          style: TextStyle(
                            color: Color.fromARGB(180, 1, 30, 100),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(180, 1, 30, 100),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(180, 1, 30, 100),
                            width: 2,
                          ),
                        ),
                        ),
                        iconEnabledColor: Theme.of(context).textTheme.bodyMedium?.color,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (val) {
                          setState(() {
                            _selectedGenre = val!;
                            _filterBooks(_searchController.text);
                          });
                        },
                        items: ['All', 'Fantasy', 'Romance', 'Adventure', 'Sci-Fi', 'Horror']
                            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 12),

                    //ricerca per voto
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedRating == -1 ? null : _selectedRating,
                        decoration: const InputDecoration(
                          label: Text(
                          "Rate",
                          style: TextStyle(
                            color: Color.fromARGB(180, 1, 30, 100),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(180, 1, 30, 100),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(180, 1, 30, 100),
                            width: 2,
                          ),
                        ),
                        ),
                        iconEnabledColor: Theme.of(context).textTheme.bodyMedium?.color,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (val) {
                          setState(() {
                            _selectedRating = val ?? -1;
                            _filterBooks(_searchController.text);
                          });
                        },
                        items: [
                          const DropdownMenuItem(
                            value: -1,
                            child: Text("All"),
                          ),
                          ...List.generate(5, (index) {
                            final ratingValue = index + 1;
                            return DropdownMenuItem(
                              value: ratingValue,
                              child: Row(
                                children: List.generate(
                                  ratingValue,
                                  (_) => const Icon(Icons.star, color: Colors.amber, size: 18),
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

            // LISTA RISULTATI
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Results',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 25,
                          color: const Color.fromARGB(221, 1, 31, 100),
                        ),
                      ),
                    ),
                  ),
                  _filteredBooks.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              'No results found',
                              style: theme.textTheme.bodyMedium?.copyWith(color: const Color.fromARGB(180, 1, 30, 100)),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
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
                                  _loadBooks(); // ricarica dopo ritorno
                                },
                                child: Container(
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
                                      // Copertina
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                        child: Image.asset(
                                          book.imagePath,
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // Info
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(book.title,
                                                  style: theme.textTheme.titleMedium?.copyWith(
                                                    color:  const Color.fromARGB(255, 106, 147, 221), 
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis),
                                              const SizedBox(height: 4),
                                              Text(book.author,
                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                    color:  const Color.fromARGB(255, 91, 142, 237), 
                                                  )),
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
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
