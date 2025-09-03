import 'package:first_app/pages/cart_page/cart.dart';
import 'package:flutter/material.dart';

class AuthorizedApp extends StatelessWidget {
  final Widget child;

  const AuthorizedApp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Cart(child: child);
  }
}
