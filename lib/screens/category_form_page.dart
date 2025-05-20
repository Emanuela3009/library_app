import 'package:flutter/material.dart';
import '../../models/category.dart';

class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({super.key});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _bookCount = 0;
  String _imagePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Category")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Number of books'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final number = int.tryParse(value ?? '');
                  if (number == null || number < 0) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _bookCount = int.tryParse(value ?? '0') ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Image path (optional)',
                  hintText: 'e.g. assets/category/fantasy.jpg',
                ),
                onSaved: (value) => _imagePath = value?.trim() ?? '',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newCategory = Category(
                      name: _name,
                      bookCount: _bookCount,
                      imagePath: _imagePath.isNotEmpty
                          ? _imagePath
                          : 'assets/category/default.jpg',
                    );

                    Navigator.pop(context, newCategory);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add Category",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}