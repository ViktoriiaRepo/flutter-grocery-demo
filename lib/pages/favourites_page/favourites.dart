// lib/pages/favourites_page/favourites.dart
import 'dart:convert';
import 'package:first_app/models/favourites_product.dart';
import 'package:first_app/models/product_short.dart';
import 'package:first_app/pages/favourites_page/favourites_data.dart';
import 'package:first_app/utils/app_settings.dart';
import 'package:flutter/material.dart';

class Favourites extends StatefulWidget {
  final Widget child;
  const Favourites({super.key, required this.child});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  static const _storageKey = 'favourites_v1';

  Map<String, FavouritesProduct> _items = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = AppSettings.getInstance().prefs.getString(_storageKey);
    if (s == null || s.isEmpty) return;

    final List raw = jsonDecode(s) as List;
    setState(() {
      _items = {
        for (final e in raw)
          e['id'].toString(): FavouritesProduct(
            product: ProductShort(
              id: e['id'].toString(),
              title: e['title'] ?? '',
              imageUrl: e['imageUrl'] ?? '',
              price: (e['price'] as num).toDouble(),
            ),
            count: 1,
          ),
      };
    });
  }

  Future<void> _save() async {
    final list = _items.values.map((fp) => {
      'id': fp.product.id,
      'title': fp.product.title,
      'imageUrl': fp.product.imageUrl,
      'price': fp.product.price,
    }).toList();
    await AppSettings.getInstance().prefs.setString(_storageKey, jsonEncode(list));
  }

  void _toggle(ProductShort p) {
    final id = p.id.toString();
    setState(() {
      if (_items.containsKey(id)) {
        _items.remove(id);
      } else {
        _items[id] = FavouritesProduct(product: p, count: 1);
      }
    });
    _save();
  }

  void _remove(String id) {
    setState(() => _items.remove(id));
    _save();
  }

  void _clear() {
    setState(() => _items = {});
    _save();
  }

  bool _isFav(String id) => _items.containsKey(id.toString());

  @override
  Widget build(BuildContext context) {
    return FavouritesData(
      products: _items.values.toList(),
      toggle: _toggle,
      remove: _remove,
      isFavourite: _isFav,
      clear: _clear,
      child: widget.child,
    );
  }
}
