import '../models/book.dart';

final List<Book> popularBooks = [
  Book(
    title: '1984',
    author: 'George Orwell',
    genre: 'Dystopia',
    plot: 'A world under totalitarian surveillance and control.',
    state: 'Completed',
    imagePath: 'assets/books/ok.jpg',
  ),
  Book(
    title: 'Brave New World',
    author: 'Aldous Huxley',
    genre: 'Science Fiction',
    plot: 'A futuristic society governed by pleasure and stability.',
    state: 'Completed',
    imagePath: 'assets/books/ok.jpg',
  ),
];

final List<Book> readingBooks = [
  Book(
    title: 'Sapiens',
    author: 'Yuval Harari',
    genre: 'History',
    plot: 'La storia dell’umanità dalle origini a oggi.',
    state: 'Reading',
    imagePath: 'assets/books/ok.jpg',
  ),
];
final List<Book> userBooks = [
Book(
    title: 'The Alchemist',
    author: 'Paulo Coelho',
    genre: 'Adventure',
    plot: 'A shepherd travels in search of his personal legend.',
    state: 'Reading',
    imagePath: 'assets/books/ok.jpg',
  ),
];
