import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/book.dart'; // necessario per usare List<Book>
import 'fake_books.dart';

final List<Category> fakeCategories = [
  Category(name: 'Romance', colorValue: Colors.pink.value),
  Category(name: 'Fantasy', colorValue: Colors.purple.value),
  Category(name: 'School', colorValue: Colors.blueGrey.value),
];


