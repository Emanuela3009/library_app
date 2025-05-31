import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; //import per i grafici
import '../models/book.dart';
import '../data/database_helper.dart';
import 'package:intl/intl.dart'; //import per formattare la data in formato "yyyy-MM"

class MyActivityPage extends StatefulWidget {
  const MyActivityPage({super.key});

  @override
  State<MyActivityPage> createState() => _MyActivityPageState();
}

//stato della pagina
class _MyActivityPageState extends State<MyActivityPage> {
  List<Book> allBooks = [];
  int readCount = 0, readingCount = 0, toReadCount = 0;
  double averageRating = 0.0;
  Map<String, int> genreCounts = {}; 
  Map<String, int> booksPerMonth = {};
  int selectedYear = DateTime.now().year; //anno iniziale mostrato

  //ritorna gli ultimi 5 anni, compreso l'anno corrente 
  List<int> get availableYears {
    final currentYear = DateTime.now().year;
    return List.generate(5, (i) => currentYear - i);
  }

  @override
  void initState() {
    super.initState();
    _loadStats(); //recupero i dati 
  }


  //funzione che legge e calcola tutte le statistiche utili 
  Future<void> _loadStats() async {
    final books = await DatabaseHelper.instance.getAllBooks();
    allBooks = books;

    //conteggio libri in base allo stato di lettura "to read" / "reading" / "completed" ; per i libri della sezione "popular now" viene considerato solo lo stato "reading" o "completed"
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

    //calcolo della media delle valutazioni solo dei libri con stato di lettura "completed" (tutti i libri)
    final completedBooks = books.where((b) => b.userState == 'Completed').toList();
    if (completedBooks.isNotEmpty) {
      final ratings = completedBooks.map((b) => b.rating ?? 0).toList();
      averageRating = ratings.reduce((a, b) => a + b) / ratings.length;
    }

    //calcolo per la distribuzione per genere (di tutti i libri "reading" o "completed")
    genreCounts.clear();
    final filteredBooks = books.where((b) =>
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

    //calcolo dei libri completati per mese e per l'anno selezionato 
    for (var book in completedBooksWithDate) {
      if (book.dateCompleted!.year == selectedYear) {
        final key = DateFormat('yyyy-MM').format(book.dateCompleted!);
        booksPerMonth[key] = (booksPerMonth[key] ?? 0) + 1;
      }
    }
    setState(() {});
  }


  //interfaccia utente 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double chartHeight = size.height * 0.3;
    final double spacing = size.height * 0.015;

    //colori assegnati per genere 
    final genreColorMap = {
      'Adventure': Colors.orange,
      'Biography': Color.fromARGB(255, 120, 144, 156), 
      'Comic': Color.fromARGB(255, 255, 202, 40),      
      'Crime': Color.fromARGB(255, 84, 110, 122),       
      'Drama': Color.fromARGB(255, 255, 138, 101),      
      'Fable': Color.fromARGB(255, 102, 187, 106),      
      'Fantasy': Color.fromARGB(255, 174, 147, 221),   
      'Gothic': Color.fromARGB(255, 58, 88, 132),       
      'History': Color.fromARGB(255, 161, 136, 127),    
      'Horror': Color.fromARGB(255, 237, 104, 95),      
      'Mystery': Color.fromARGB(255, 121, 85, 72),      
      'Poetry': Color.fromARGB(255, 255, 183, 77),      
      'Romance': Color.fromARGB(255, 236, 106, 149),   
      'Satire': Color.fromARGB(255, 255, 112, 67),      
      'Sci-Fi': Color.fromARGB(255, 132, 212, 248),     
      'Thriller': Color.fromARGB(255, 94, 53, 177),     
      'Tragedy': Color.fromARGB(255, 149, 117, 205),    
    };

    return Scaffold(

      body: LayoutBuilder( //layout responsive
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600; //cambio layout se la larghezza è >600 pixel

          return SingleChildScrollView( //pagina scrollabile
            padding: EdgeInsets.symmetric(
              horizontal: isWideScreen ? 32 : 16,
              vertical: 16,
            ),
            child: Align( 
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWideScreen ? 700 : double.infinity,
                ),
                child: Column( //tutti gli elementi costruiti (allineati e centrati) tenuti in colonna
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("Reading Progress Summary", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth = constraints.maxWidth;
                final bool isVerySmall = maxWidth < 370;
                final bool isWide = maxWidth > 700;

                final double cardWidth = isVerySmall
                    ? maxWidth * 0.9
                    : isWide
                        ? 220
                        : maxWidth / 3 - 16;

                return Center(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(width: cardWidth, child: _infoCard("Completed", readCount, size)),
                      SizedBox(width: cardWidth, child: _infoCard("Reading", readingCount, size)),
                      SizedBox(width: cardWidth, child: _infoCard("To Read", toReadCount, size)),
                    ],
                  ),
                );
              },
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
                          color: const Color.fromARGB(255, 0, 0, 0),
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

                        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
                        final chartWidth = isLandscape ? 700.0 : MediaQuery.of(context).size.width - 32;

                        return SizedBox(
                          height: chartHeight,
                          child: SizedBox(
                            width: chartWidth,
                              child: LineChart(
                                LineChartData(
                              minY: 0,
                              maxY: ((maxCount + 4) ~/ 5) * 5.0,
                              gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                                drawVerticalLine: true,
                                verticalInterval: 1, 
                                horizontalInterval: 5,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 1,
                                ),
                                getDrawingVerticalLine: (value) => FlLine(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 1,
                                ),
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
                                    interval: 1, 
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      if (index < 0 || index > 11) return const SizedBox.shrink();
                                      const monthLabels = [
                                        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                                      ];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(monthLabels[index], style: const TextStyle(fontSize: 10)),
                                      );
                                    }
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
                                ),
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
          ),
        );
      },
    ),
  );
}

  Widget _infoCard(String label, int count, Size size) {
    return SizedBox(
      width: 200,
      height: 100,
      child: Card(
        color: const Color.fromARGB(255, 249, 246, 252),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//grafico per la visualizzazione della distribuzione per genere
class _GenrePieChart extends StatelessWidget {
  final Map<String, int> data;

  const _GenrePieChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<int>(0, (a, b) => a + b).toDouble();

    final genreColorMap = {
    'Adventure': Colors.orange,
    'Biography': Color.fromARGB(255, 120, 144, 156), 
    'Comic': Color.fromARGB(255, 255, 202, 40),      
    'Crime': Color.fromARGB(255, 84, 110, 122),       
    'Drama': Color.fromARGB(255, 255, 138, 101),      
    'Fable': Color.fromARGB(255, 102, 187, 106),   
    'Fantasy': Color.fromARGB(255, 174, 147, 221),   
    'Gothic': Color.fromARGB(255, 58, 88, 132),       
    'History': Color.fromARGB(255, 161, 136, 127),    
    'Horror': Color.fromARGB(255, 237, 104, 95),   
    'Mystery': Color.fromARGB(255, 121, 85, 72),      
    'Poetry': Color.fromARGB(255, 255, 183, 77),      
    'Romance': Color.fromARGB(255, 236, 106, 149),    
    'Satire': Color.fromARGB(255, 255, 112, 67),      
    'Sci-Fi': Color.fromARGB(255, 132, 212, 248),    
    'Thriller': Color.fromARGB(255, 94, 53, 177),   
    'Tragedy': Color.fromARGB(255, 149, 117, 205),    
    };

    return PieChart( //costruzione grafico con i dati disponibili 
      PieChartData(
      sections: data.entries.map((entry) {
          final genre = entry.key;
          final value = entry.value;
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