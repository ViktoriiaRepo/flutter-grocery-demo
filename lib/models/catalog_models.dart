import 'package:flutter/material.dart';

class ProductItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String category;
  final double price;
  final String? section;
  final VoidCallback onAdd;

  const ProductItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.category,
    required this.price,
    this.section,
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
