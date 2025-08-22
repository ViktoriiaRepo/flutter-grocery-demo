import 'package:first_app/models/catalog_models.dart' show ProductItem;
import 'package:first_app/api/server_api.dart';
import 'package:first_app/pages/product_details_page/product_detail_page.dart';
import 'package:flutter/material.dart';

class ProductLoader extends StatelessWidget {
  final String id;
  final ProductItem? preview;
  const ProductLoader({super.key, required this.id, this.preview});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductItem>(
      future: ServerApi().fetchProductById(id),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          if (preview != null) return ProductDetailPage(product: preview!);
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          if (preview != null) return ProductDetailPage(product: preview!);
          return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
        }
        return ProductDetailPage(product: snap.data!);
      },
    );
  }
}
