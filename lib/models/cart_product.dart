import 'package:first_app/models/product_short.dart';


class CartProduct {
  final ProductShort product;
  int count;

  CartProduct({
    required this.product,
    required this.count,
  });
}