import 'book.dart';

class Category {
  final String name;
  final String imagePath;
  final List<Book> books;

  Category({
    required this.name,
    required this.imagePath,
    this.books = const [],
  });

  int get bookCount => books.length;
}
