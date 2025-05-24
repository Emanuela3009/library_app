import '../models/book.dart';

// Libri predefiniti da inserire nel database alla prima esecuzione
final List<Book> popularBooks = [
  Book(
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    genre: "Horror",
    plot: "A mysterious millionaire throws lavish parties in the 1920s.",
    imagePath: "assets/books/ok.jpg",
    rating: 0,
    userState: "To Read",
    isUserBook: false,
  ),
  Book(
    title: "Harry Potter and the Philosopher's Stone",
    author: "J.K. Rowling",
    genre: "Fantasy",
    plot: "A young wizard discovers his destiny at Hogwarts.",
    imagePath: "assets/books/ok.jpg",
    rating: 0,
    userState: "To Read",
    isUserBook: false,
  ),
  Book(
    title: "1984",
    author: "George Orwell",
    genre: "Adventure",
    plot: "A man lives under constant surveillance in a totalitarian regime.",
    imagePath: "assets/books/ok.jpg",
    rating: 0,
    userState: "To Read",
    isUserBook: false,
  ),
  Book(
    title: "The Lord of the Rings",
    author: "J.R.R. Tolkien",
    genre: "Fantasy",
    plot:
        "A group of heroes sets out to destroy a powerful ring and defeat evil.",
    imagePath: "assets/books/ok.jpg",
    rating: 0,
    userState: "To Read",
    isUserBook: false,
  ),
  Book(
    title: "The Picture of Dorian Gray",
    author: "Oscar Wilde",
    genre: "Gothic",
    plot:
        "A man stays young while his portrait ages, reflecting his corruption.",
    imagePath: "assets/books/ok.jpg",
    rating: 0,
    userState: "To Read",
    isUserBook: false,
  ),
  Book(
    title: "Frankenstein",
    author: "Mary Shelley",
    genre: "Horror",
    plot: "A scientist creates life and faces the consequences of playing god.",
    imagePath: "assets/books/ok.jpg",
    rating: 0,
    userState: "To Read",
    isUserBook: false,
  ),
  Book(
    title: "The Little Prince",
    author: "Antoine de Saint-Exupéry",
    genre: "Fable",
    plot:
        "A pilot stranded in the desert meets a young prince from another planet.",
    imagePath: "assets/books/ok.jpg",
    rating: 0,
    userState: "To Read",
    isUserBook: false,
  ),
  Book(
    title: "The Chronicles of Narnia",
    author: "C.S. Lewis",
    genre: "Fantasy",
    plot: "Children discover a magical world through a wardrobe.",
    imagePath: "assets/books/ok.jpg",
    rating: 0,
    userState: "To Read",
    isUserBook: false,
  ),

  Book(
  title: "Alice in Wonderland",
  author: "Lewis Carroll",
  genre: "Fantasy",
  plot: "Alice, a curious young girl, falls down a rabbit hole into a whimsical world where she encounters talking animals, strange characters, and nonsensical adventures.",
  imagePath: "assets/books/alice.jpg", // sostituisci con il nome corretto se necessario
  rating: 0,
  userState: "To Read",
  isUserBook:false,
),
];
