import '../models/book.dart';

// Libri predefiniti da inserire nel database alla prima esecuzione
final List<Book> popularBooks = [
  Book(
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    genre: "Classic",
    plot: "A mysterious millionaire throws lavish parties in the 1920s.",
    imagePath: "assets/books/ok.jpg",
    rating: 5,
    userState: "Completed",
  ),
  Book(
    title: "Harry Potter and the Philosopher's Stone",
    author: "J.K. Rowling",
    genre: "Fantasy",
    plot: "A young wizard discovers his destiny at Hogwarts.",
    imagePath: "assets/books/ok.jpg",
    rating: 4,
    userState: "Reading",
  ),
  Book(
    title: "1984",
    author: "George Orwell",
    genre: "Dystopian",
    plot: "A man lives under constant surveillance in a totalitarian regime.",
    imagePath: "assets/books/ok.jpg",
    rating: 4,
    userState: "To Read",
  ),
];