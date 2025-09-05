// lib/pages/favourites_page/favourites_data.dart
import 'package:first_app/models/favourites_product.dart';
import 'package:first_app/models/product_short.dart';
import 'package:flutter/material.dart';

class FavouritesData extends InheritedWidget {
  final List<FavouritesProduct> products;

  final void Function(ProductShort) toggle;

  final void Function(String id) remove;

  final bool Function(String id) isFavourite;

  final VoidCallback clear;

  final int totalCount;

  FavouritesData({
    super.key,
    required this.products,
    required this.toggle,
    required this.remove,
    required this.isFavourite,
    required this.clear,
    required super.child,
  }) : totalCount = products.length;

  @override
  bool updateShouldNotify(covariant FavouritesData old) =>
      totalCount != old.totalCount;

  static FavouritesData of(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<FavouritesData>();
    assert(data != null, "NoFavouritesData found in context");
    return data!;
  }

  static FavouritesData get(BuildContext context) {
    final data = context.getInheritedWidgetOfExactType<FavouritesData>();
    assert(data != null, "NoFavouritesData found in context");
    return data!;
  }
}
