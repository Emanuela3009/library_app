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
    return List.generate(5, (i) => currentYear - i);
  }

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final books = await DatabaseHelper.instance.getAllBooks();
    allBooks = books;

    readCount = books.where((b) =>
      b.userState == 'Completed' &&
      (b.isUserBook || b.userState != 'To Read')
    ).length;

    readingCount = books.where((b) =>
      b.userState == 'Reading' &&
      (b.isUserBook || b.userState != 'To Read')
    ).length;

    toReadCount = books.where((b) =>
      b.userState == 'To Read' &&
      b.isUserBook
    ).length;

    final completedBooks = books.where((b) => b.userState == 'Completed').toList();
    if (completedBooks.isNotEmpty) {
      final ratings = completedBooks.map((b) => b.rating ?? 0).toList();
      averageRating = ratings.reduce((a, b) => a + b) / ratings.length;
    }

    genreCounts.clear();
    final filteredBooks = books.where((b) =>
      b.isUserBook &&
      (b.userState == 'Reading' || b.userState == 'Completed') &&
      b.genre.trim().isNotEmpty).toList();

    for (var book in filteredBooks) {
      final genre = book.genre.trim();
      genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
    }

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
    final size = MediaQuery.of(context).size;
    final double chartHeight = size.height * 0.3;
    final double spacing = size.height * 0.015;
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
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reading Progress Summary", style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color.fromARGB(255, 111, 153, 241),
              fontWeight: FontWeight.bold,
            )),
            SizedBox(height: spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoCard("Completed", readCount, size),
                _infoCard("Reading", readingCount, size),
                _infoCard("To Read", toReadCount, size),
              ],
            ),
            SizedBox(height: spacing * 2),
            Text("Your reading taste", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: spacing),
            genreCounts.isEmpty
                ? const Text("No data available")
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: genreCounts.entries.map((entry) {
                          final genre = entry.key;
                          final color = genreColorMap[genre] ?? Colors.grey;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 6),
                                Text(genre, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 24),
                      Expanded(child: SizedBox(height: chartHeight, child: _GenrePieChart(data: genreCounts))),
                    ],
                  ),
            SizedBox(height: spacing * 2),
            Text("Rating of completed books", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: spacing),
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
                      const Text("No completed books yet", style: TextStyle(fontStyle: FontStyle.italic))
                    else
                      ...completedBooks.map((book) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(book.title, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(width: 6),
                                Text('${book.rating}/5', style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 4),
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                              ],
                            ),
                          )),
                    SizedBox(height: spacing),
                    Text("Average:", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal)),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < averageRating.round() ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    SizedBox(height: spacing * 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Books read per month", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color.fromARGB(255, 111, 153, 241),
                          fontWeight: FontWeight.bold,
                        )),
                        DropdownButton<int>(
                          value: selectedYear,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => selectedYear = val);
                              _loadStats();
                            }
                          },
                          items: availableYears.map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    Builder(
                      builder: (context) {
                        final filtered = Map.fromEntries(
                          booksPerMonth.entries.where((e) => e.key.startsWith('$selectedYear-')),
                        );

                        final months = List.generate(12, (i) => DateFormat('yyyy-MM').format(DateTime(selectedYear, i + 1)));
                        final maxCount = filtered.isEmpty ? 0 : filtered.values.reduce((a, b) => a > b ? a : b);

                        return SizedBox(
                          height: chartHeight,
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              maxY: ((maxCount + 4) ~/ 5) * 5.0,
                              gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                                horizontalInterval: 5,
                                getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval: 5,
                                    getTitlesWidget: (value, _) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
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
                                border: const Border(bottom: BorderSide(color: Colors.grey)),
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

  Widget _infoCard(String label, int count, Size size) {
    return SizedBox(
      width: size.width * 0.28,
      child: Card(
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
              decoration: TextDecoration.underline,
              color: Colors.black,
            ),
          );
        }).toList(),
      ),
    );
  }
}