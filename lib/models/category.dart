import 'book.dart';
import 'package:flutter/material.dart';

class Category {
  final String name;
  final List<Book> books;
  final Color color; 

  Category({
    required this.name,
    this.books = const [],
    required this.color,
  });

  int get bookCount => books.length;
}
