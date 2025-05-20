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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Category")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newCategory = Category(
                      name: _name,
                      bookCount: _bookCount,
                    );

                    Navigator.pop(context, newCategory); // ritorna al chiamante
                  }
                },
                child: const Text("Add Category"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
