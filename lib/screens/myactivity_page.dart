import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import 'package:intl/intl.dart';



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
  Map<String, int> booksPerMonth = {};
  int selectedYear = DateTime.now().year;
  List<int> get availableYears {
  final currentYear = DateTime.now().year;
  return List.generate(5, (i) => currentYear - i); // ultimi 5 anni
}

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

  // Conteggio libri letti per mese/anno
  booksPerMonth.clear();
  final completedBooksWithDate = books
      .where((b) => b.userState == 'Completed' && b.dateCompleted != null)
      .toList();

  for (var book in completedBooksWithDate) {
  if (book.dateCompleted!.year == selectedYear) {
    final key = DateFormat('yyyy-MM').format(book.dateCompleted!);
    booksPerMonth[key] = (booksPerMonth[key] ?? 0) + 1;
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Books read per month",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color.fromARGB(255, 111, 153, 241),
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<int>(
                value: selectedYear,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 111, 153, 241),
                ),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      selectedYear = val;
                    });
                    _loadStats(); // Ricarica i dati con il nuovo anno
                  }
                },
                items: availableYears.map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
              ),
            ],
          ),
          Builder(
            builder: (context) {
              // Ordina i mesi cronologicamente
              final filtered = Map.fromEntries(
                booksPerMonth.entries.where((e) => e.key.startsWith('$selectedYear-')),
              );

              final months = List.generate(
                12,
                (i) => DateFormat('yyyy-MM').format(DateTime(selectedYear, i + 1)),
              );

              final maxCount = filtered.isEmpty
                  ? 0
                  : filtered.values.reduce((a, b) => a > b ? a : b);

              return SizedBox(
                height: 260,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: ((maxCount + 9) ~/ 10) * 10.0,
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      horizontalInterval: 5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 5,
                          getTitlesWidget: (value, meta) =>
                              Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < 12) {
                              final label = DateFormat('MMM', 'en_US').format(DateTime(0, index + 1));
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(label, style: const TextStyle(fontSize: 10)),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(12, (i) {
                          final key = months[i];
                          final value = filtered[key] ?? 0;
                          return FlSpot(i.toDouble(), value.toDouble());
                        }),
                        isCurved: false,
                        color: Colors.black,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    lineTouchData: LineTouchData(enabled: false),
                  ),
                ),
              );
            },
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