// lib/catalog_data.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'models/catalog_models.dart';

class CatalogCategory {
  final String id;
  final String title;
  final String imageUrl;
  const CatalogCategory({required this.id, required this.title, required this.imageUrl});
}

class CatalogData {
  static bool _loaded = false;

  static List<ProductItem> allProducts = [];
  static List<ProductItem> exclusive = [];
  static List<ProductItem> bestSelling = [];

  static List<CatalogCategory> categories = [];
  static Map<String, String> categoryTitles = {};

  static Future<void> load() async {
    if (_loaded) return;

    final raw = await rootBundle.loadString('assets/data/catalog.json');
    final map = json.decode(raw) as Map<String, dynamic>;

    // categories
    final cats = (map['categories'] as List?) ?? const [];
    categories = cats.map((c) {
      final m = c as Map<String, dynamic>;
      return CatalogCategory(
        id: m['id'] as String,
        title: m['title'] as String,
        imageUrl: (m['imageUrl'] ?? '') as String,
      );
    }).toList();
    categoryTitles = { for (final c in categories) c.id : c.title };

    // products
    allProducts = ((map['products'] as List?) ?? const []).map((e) {
      final m = e as Map<String, dynamic>;
      return ProductItem(
        title: m['title'] as String,
        subtitle: (m['subtitle'] ?? '') as String,
        imageUrl: (m['imageUrl'] ?? '') as String,
        price: (m['price'] as num).toDouble(),
        category: m['category'] as String,
        section: m['section'] as String?,
        onAdd: () => debugPrint('Add ${m['title']}'),
      );
    }).toList();

    final hasSection = allProducts.any((p) => (p.section ?? '').isNotEmpty);
    if (hasSection) {
      exclusive   = allProducts.where((p) => p.section == 'exclusive').toList();
      bestSelling = allProducts.where((p) => p.section == 'best').toList();
    } else {
      exclusive   = allProducts.where((p) => p.category == 'fruits' || p.category == 'oil').toList();
      bestSelling = allProducts.where((p) => p.category == 'beverages' || p.category == 'bakery').toList();
    }

    _loaded = true;
  }

  static Future<void> ensureLoaded() => load();

  static String categoryTitle(String id) => categoryTitles[id] ?? id;

  static List<CatalogCategory> searchCategories(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return categories;
    return categories.where((c) => c.title.toLowerCase().contains(query)).toList();
  }
}
