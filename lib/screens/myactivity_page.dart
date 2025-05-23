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

    readCount = books.where((b) => b.userState == 'Read').length;
    readingCount = books.where((b) => b.userState == 'Reading').length;
    toReadCount = books.where((b) => b.userState == 'To Read').length;

    final readBooks = books.where((b) => b.userState == 'Read').toList();
    if (readBooks.isNotEmpty) {
      final ratings = readBooks.map((b) => b.rating ?? 0).toList();
      averageRating = ratings.reduce((a, b) => a + b) / ratings.length;
    }

    // Conteggio per genere solo dei libri letti
    genreCounts.clear();
    for (var book in readBooks) {
      genreCounts[book.genre] = (genreCounts[book.genre] ?? 0) + 1;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reading Progress Summary", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoCard("Completed", readCount),
                _infoCard("Currently reading", readingCount),
                _infoCard("To read", toReadCount),
              ],
            ),
            const SizedBox(height: 24),
            Text("Your reading taste", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            genreCounts.isEmpty
                ? const Text("No data available")
                : SizedBox(height: 200, child: _GenrePieChart(data: genreCounts)),
            const SizedBox(height: 24),
            Text("Average rating of completed books", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
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
    final colors = [Colors.blue, Colors.green, Colors.purple, Colors.orange, Colors.red];

    return PieChart(
      PieChartData(
        sections: data.entries.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final genre = entry.value.key;
          final value = entry.value.value;
          final percent = (value / total * 100).toStringAsFixed(1);
          return PieChartSectionData(
            value: value.toDouble(),
            title: '$genre\n$percent%',
            radius: 60,
            color: colors[index % colors.length],
            titleStyle: const TextStyle(fontSize: 12),
          );
        }).toList(),
      ),
    );
  }
}