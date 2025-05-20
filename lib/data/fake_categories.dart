import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/book.dart'; // necessario per usare List<Book>
import 'fake_books.dart';

final List<Category> fakeCategories = [
  Category(
    name: 'Romance',
    color: Colors.pink.shade200,
    books: [
      userBooks[0],
    ], // puoi aggiungere dei Book qui se vuoi
  ),
  Category(
    name: 'Fantasy',
    color: Colors.deepPurple.shade200,
    books: [
      popularBooks[1],
    ],
  ),
  Category(
    name: 'Thriller', 
    color: Colors.red.shade200,
    books: [
      popularBooks[0], // 1984
      readingBooks[0], // Sapiens
    ],
  ),
];


