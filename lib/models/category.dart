import 'book.dart';

class Category {
  final String name;
<<<<<<< HEAD
=======
   int bookCount;
>>>>>>> 6f1da991720f28de7eb34bd9643422293af04b93
  final String imagePath;
  final List<Book> books;

  Category({
    required this.name,
    required this.imagePath,
    this.books = const [],
  });

  int get bookCount => books.length;
}
