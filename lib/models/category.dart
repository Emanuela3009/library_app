import 'package:flutter/material.dart';

class Category {
  int? id;
  final String name;
  int? colorValue;

  Category({
    this.id,
    required this.name,
    this.colorValue,
  });

  Color? get color =>
      colorValue != null ? Color(colorValue!) : null;

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'colorValue': colorValue,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      colorValue: map['colorValue'],
    );
  }
}