import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/book.dart';
import '../data/database_helper.dart';

class MyActivityPage extends StatefulWidget {
  const MyActivityPage({super.key});

  @override
  State<MyActivityPage> createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> {
  List<Book> allBooks = [];
  int readCount = 0;
  int readingCount = 0;
  int toReadCount = 0;
  double averageRating = 0.0;
  Map<String, int> genreCounts = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
  final books = await DatabaseHelper.instance.getAllBooks();
  allBooks = books;

  //Conteggi per stato 
  readCount = books.where((b) => b.userState == 'Completed').length;
  readingCount = books.where((b) => b.userState == 'Reading').length;
  toReadCount = books.where((b) => b.userState == 'To Read').length;

  //Valutazione media solo dei libri completati
  final completedBooks = books.where((b) => b.userState == 'Completed').toList();
  if (completedBooks.isNotEmpty) {
    final ratings = completedBooks.map((b) => b.rating ?? 0).toList();
    averageRating = ratings.reduce((a, b) => a + b) / ratings.length;
  }

  //Distribuzione per genere: TUTTI i libri presenti
  genreCounts.clear();
  for (var book in books) {
    final genre = book.genre?.trim();
    if (genre != null && genre.isNotEmpty) {
      genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
    }
  }

  setState(() {});
}

  @override
Widget build(BuildContext context) {
  final genreColorMap = {
    'Fantasy': const Color.fromARGB(255, 174, 147, 221),
    'Romance': const Color.fromARGB(255, 236, 106, 149),
    'Adventure': Colors.orange,
    'Sci-Fi': const Color.fromARGB(255, 132, 212, 248),
    'Horror': const Color.fromARGB(255, 237, 104, 95),
  };

  return Scaffold(
    appBar: AppBar(title: const Text('Activity')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Reading Progress Summary", style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color.fromARGB(255, 111, 153, 241),
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoCard("Completed", readCount),
              _infoCard("Reading", readingCount),
              _infoCard("To Read", toReadCount),
            ],
          ),
          const SizedBox(height: 24),
          Text("Your reading taste", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          genreCounts.isEmpty
              ? const Text("No data available")
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Legenda a sinistra
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: genreCounts.entries.map((entry) {
                        final genre = entry.key;
                        final color = genreColorMap[genre] ?? Colors.grey;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                genre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 24),
                    // Grafico a destra
                    Expanded(
                      child: SizedBox(
                        height: 200,
                        child: _GenrePieChart(data: genreCounts),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),
          Text("Rating of completed books", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final completedBooks = allBooks
                    .where((b) => b.userState == 'Completed' && b.rating != null)
                    .toList()
                  ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (completedBooks.isEmpty)
                      const Text(
                        "No completed books yet",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )
                    else
                      ...completedBooks.map((book) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    book.title,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${book.rating}/5',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                              ],
                            ),
                          )),
                    const SizedBox(height: 12),
                    Text("Average:", style: Theme.of(context).textTheme.bodyLarge),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < averageRating.round() ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String label, int count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('$count', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class _GenrePieChart extends StatelessWidget {
  final Map<String, int> data;
  const _GenrePieChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0, (a, b) => a + b).toDouble();
    final genreColorMap = {
      'Fantasy': const Color.fromARGB(255, 174, 147, 221),
      'Romance': const Color.fromARGB(255, 236, 106, 149),
      'Adventure': Colors.orange,
      'Sci-Fi': const Color.fromARGB(255, 132, 212, 248),
      'Horror': const Color.fromARGB(255, 237, 104, 95),
    };

    return PieChart(
      PieChartData(
        sections: data.entries.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final genre = entry.value.key;
          final value = entry.value.value;
          final percent = (value / total * 100).toStringAsFixed(1);
          return PieChartSectionData(
            value: value.toDouble(),
            title: '$percent%',
            radius: 60,
            color: genreColorMap[genre] ?? Colors.grey,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline, // Sottolineato
              color: Colors.black, // Visibile su sfondi colorati
),
          );
        }).toList(),
      ),
    );
  }
}