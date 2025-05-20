import '../models/category.dart';
import '../models/book.dart'; // necessario per usare List<Book>
import 'fake_books.dart';

final List<Category> fakeCategories = [
  Category(
    name: 'Romance',
    imagePath: 'assets/category/romance.jpg',
    books: [
      userBooks[0],
    ], // puoi aggiungere dei Book qui se vuoi
  ),
  Category(
    name: 'Fantasy',
    imagePath: 'assets/category/fantasy.jpg',
    books: [
      popularBooks[1],
    ],
  ),
  Category(
    name: 'Thriller', 
    imagePath: 'assets/category/thriller.jpg',
    books: [
      popularBooks[0], // 1984
      readingBooks[0], // Sapiens
    ],
  ),
];


