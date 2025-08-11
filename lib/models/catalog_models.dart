import 'package:flutter/material.dart';

class ProductItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;
  final VoidCallback onAdd;

  const ProductItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
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
