import '../models/category.dart';
import '../models/book.dart'; // per usare List<Book>

class CategoryService {
  static final List<Category> _categories = [
    Category(
      name: 'Romance',
      imagePath: 'assets/images/romance.png',
      books: [],
    ),
    Category(
      name: 'Fantasy',
      imagePath: 'assets/images/fantasy.png',
      books: [],
    ),
    Category(
      name: 'Spanish',
      imagePath: 'assets/images/spanish.png',
      books: [],
    ),
    Category(
      name: 'School',
      imagePath: 'assets/images/school.png',
      books: [],
    ),
  ];

  static List<Category> get categories => _categories;

  static void addCategory(Category category) {
    _categories.add(category);
  }

  static void addBookToCategory(Book book, String categoryName) {
    final category = _categories.firstWhere(
      (c) => c.name == categoryName,
      orElse: () => throw Exception('Category not found'),
    );
    category.books.add(book);
  }
}
