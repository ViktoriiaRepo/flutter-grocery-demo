// lib/pages/cart_page/cart_data.dart
import 'package:first_app/models/cart_product.dart';
import 'package:first_app/models/product_short.dart';
import 'package:flutter/material.dart';

class CartData extends InheritedWidget {
  final List<CartProduct> products;

  final void Function(ProductShort) addProduct;
  final void Function(String id) increment;
  final void Function(String id) decrement;
  final void Function(String id) remove;
  final VoidCallback clear;

  final int totalCount;
  final double totalPrice;

  CartData({
    super.key,
    required this.products,
    required this.addProduct,
    required this.increment,
    required this.decrement,
    required this.remove,
    required this.clear,
    required super.child,
  })  : totalCount = products.fold<int>(0, (s, e) => s + e.count),
        totalPrice = products.fold<double>(0.0, (s, e) => s + e.count * e.product.price);

  @override
  bool updateShouldNotify(covariant CartData old) =>
      totalCount != old.totalCount || totalPrice != old.totalPrice;

  static CartData of(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<CartData>();
    assert(data != null, "NoCartData found in context");
    return data!;
  }

  static CartData get(BuildContext context) {
    final data = context.getInheritedWidgetOfExactType<CartData>();
    assert(data != null, "NoCartData found in context");
    return data!;
  }
}
