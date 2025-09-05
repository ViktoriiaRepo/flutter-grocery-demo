import 'package:flutter/material.dart';


class ProductItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String category;
  final double price;
  final String? section;
  final String? description;
  final Map<String, String> nutritions;
  final VoidCallback onAdd;



  const ProductItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.category,
    required this.price,
    this.section,
    this.description,
    this.nutritions = const <String, String>{},
    required this.onAdd,
  });
}

class CategoryItem {
  final String title;
  final String imageUrl;
  final Color background;
  final VoidCallback onTap;

  const CategoryItem({
    required this.title,
    required this.imageUrl,
    required this.background,
    required this.onTap,
  });
}
