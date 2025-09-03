// lib/pages/cart_page/cart.dart
import 'package:first_app/models/cart_product.dart';
import 'package:first_app/models/product_short.dart';
import 'package:first_app/pages/cart_page/cart_data.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  final Widget child;
  const Cart({super.key, required this.child});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  Map<String, CartProduct> products = {};

  @override
  Widget build(BuildContext context) {
    return CartData(
      products: products.values.toList(),
      addProduct: _onAddProduct,
      increment: _incById,
      decrement: _decById,
      remove: _removeById,
      clear: _onClear,
      child: widget.child,
    );
  }

  void _onAddProduct(ProductShort product) {
    final key = product.id.toString();
    setState(() {
      if (products.containsKey(key)) {
        final old = products[key]!;
        products[key] = CartProduct(product: old.product, count: old.count + 1);
      } else {
        products[key] = CartProduct(product: product, count: 1);
      }
    });
  }

  void _incById(String id) {
    final key = id;
    if (!products.containsKey(key)) return;
    setState(() {
      final old = products[key]!;
      products[key] = CartProduct(product: old.product, count: old.count + 1);
    });
  }

  void _decById(String id) {
    final key = id;
    if (!products.containsKey(key)) return;
    setState(() {
      final old = products[key]!;
      final next = old.count - 1;
      if (next <= 0) {
        products.remove(key);
      } else {
        products[key] = CartProduct(product: old.product, count: next);
      }
    });
  }

  void _removeById(String id) {
    setState(() {
      products.remove(id);
    });
  }

  void _onClear() {
    setState(() {
      products = {};
    });
  }
}
