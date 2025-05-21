
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';
import '../models/category.dart';


//Implementa il pattern Singleton: significa che puoi accedere al database da qualunque parte dell’app con DatabaseHelper.instance.

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

//Crea fisicamente il file del database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'library_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        author TEXT,
        genre TEXT,
        plot TEXT,
        imagePath TEXT,
        comment TEXT,
        rating INTEGER,
        userState TEXT,
        categoryId INTEGER
      )
    ''');

    await db.execute('''
     CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      colorValue INTEGER
    )
    ''');
  }

  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert('books', book.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final result = await db.query('books');
    return result.map((map) => Book.fromMap(map)).toList();
  }

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final result = await db.query('categories');
    return result.map((map) => Category.fromMap(map)).toList();
  }


  Future<void> populateInitialBooks(List<Book> initialBooks) async {
  final db = await database;

  // Controlla se la tabella "books" è già popolata
  final count = Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM books'),
  );

  // Se è vuota, inserisce i libri iniziali
  if (count == 0) {
    for (var book in initialBooks) {
      await insertBook(book);
    }
  }
}

Future<void> populateInitialCategories(List<Category> initialCategories) async {
  final db = await database;
  final count = Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM categories'),
  );

  if (count == 0) {
    for (var category in initialCategories) {
      await insertCategory(category);
    }
  }
}
}
