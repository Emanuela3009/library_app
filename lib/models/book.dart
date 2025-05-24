class Book {
  int? id;
  final String title;
  final String author;
  final String genre;
  final String plot;
  final String imagePath;
  String? comment;
  int? rating;
  String? userState;
  int? categoryId;
  bool isUserBook; 
  bool isFavorite;
  DateTime? dateCompleted;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.plot,
    required this.imagePath,
    this.comment,
    this.rating,
    this.userState,
    this.categoryId,
    this.isUserBook = false,
    this.isFavorite = false,
    this.dateCompleted,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'title': title,
      'author': author,
      'genre': genre,
      'plot': plot,
      'imagePath': imagePath,
      'comment': comment,
      'rating': rating,
      'userState': userState,
      'categoryId': categoryId,
      'isUserBook': isUserBook ? 1 : 0,
      'isFavorite': isFavorite ? 1 : 0,
      'dateCompleted': dateCompleted?.toIso8601String(),
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      genre: map['genre'],
      plot: map['plot'],
      imagePath: map['imagePath'],
      comment: map['comment'],
      rating: map['rating'],
      userState: map['userState'],
      categoryId: map['categoryId'],
      isUserBook: (map['isUserBook'] ?? 0) == 1,
      isFavorite: map['isFavorite'] == 1,
      dateCompleted: map['dateCompleted'] != null ? DateTime.parse(map['dateCompleted']) : null,
    );
  }
}
