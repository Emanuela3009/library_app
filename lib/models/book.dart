class Book {
  final String title;
  final String author;
  final String genre;
  final String plot;
  final String state;       // es: in lettura, completato, da leggere
  final String imagePath;   // path immagine da asset o URL

  Book({
    required this.title,
    required this.author,
    required this.genre,
    required this.plot,
    required this.state,
    required this.imagePath,
  });
}