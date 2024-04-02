import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatelessWidget {
  static const routeName = '/category';
  final String id;
  const CategoryDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Placeholder(child: Text('Category Detail Screen with id $id'));
  }
}
