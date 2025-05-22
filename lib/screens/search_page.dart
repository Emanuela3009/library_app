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

  // String _selectedGenre = 'All'; // ← opzionale: filtro per genere

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final books = await DatabaseHelper.instance.getAllBooks();
    setState(() {
      _allBooks = books;
      _filteredBooks = []; // inizialmente vuoto
    });
 }


  void _filterBooks(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredBooks = []; // se non stai scrivendo niente, allora niente risultati
      } else {
        _filteredBooks = _allBooks.where((book) {
          final titleMatch = book.title.toLowerCase().contains(lowerQuery);
          final authorMatch = book.author.toLowerCase().contains(lowerQuery);
          return titleMatch || authorMatch;
        }).toList();
      }
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
        title: Text(
          "Search Books",
          style: theme.textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo ricerca con lente e clear icon
            TextField(
              controller: _searchController,
              onChanged: _filterBooks,
              decoration: InputDecoration(
                hintText: 'Search by title or author',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1E2A78), size: 28),
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
                fillColor: const Color.fromARGB(20, 1, 30, 100),
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

            // Filtra per genere (opzionale)
            /*
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedGenre,
              decoration: const InputDecoration(labelText: 'Filter by genre'),
              items: ['All', 'Fantasy', 'Romance', 'Adventure', 'Sci-Fi', 'Horror']
                  .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedGenre = value!);
                _filterBooks(_searchController.text);
              },
            ),
            */

            const SizedBox(height: 20),

            Expanded(
              child: _filteredBooks.isEmpty
                  ? Center(
                      child: Text(
                        'No results found',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
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
                                // Immagine
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
                                        Text(
                                          book.title,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            color: const Color(0xFF164EC7),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          book.author,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: const Color(0xFF101F83),
                                          ),
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
                                        )
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
    );
  }
}
