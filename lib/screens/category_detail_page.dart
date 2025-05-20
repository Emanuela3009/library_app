import 'package:flutter/material.dart';
import '../../models/category.dart';

class CategoryDetailPage extends StatelessWidget {
  final Category category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final books = category.books;
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You have ${category.bookCount} books',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: books.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Expanded(child: Placeholder()), // immagine
                        const SizedBox(height: 8),
                        Text(
                          books[index].title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          books[index].author,
                        ),
                        const Text('⭐ 4.9/5',
                            style: TextStyle(color: Colors.purple)),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
