import 'package:first_app/models/product_short.dart';


class FavouritesProduct {
  final ProductShort product;
  int count;

  FavouritesProduct({
    required this.product,
    required this.count,
  });
}