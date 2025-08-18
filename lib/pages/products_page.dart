// lib/pages/products_page.dart
import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../models/catalog_models.dart';
import '../catalog_data.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({
    super.key,
    this.categoryId,
    this.section,
    this.showSearch = false,
  });

  final String? categoryId;
  final String? section;
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CatalogData.ensureLoaded(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        List<ProductItem> items = CatalogData.allProducts;
        if (categoryId != null) {
          items = items.where((p) => p.category == categoryId).toList();
        }
        if (section == 'exclusive') {
          items = CatalogData.exclusive;
        } else if (section == 'best') {
          items = CatalogData.bestSelling;
        }

        final title = categoryId != null
            ? CatalogData.categoryTitle(categoryId!)
            : (section == 'exclusive'
            ? 'Exclusive Offer'
            : section == 'best'
            ? 'Best Selling'
            : 'Products');

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: GridView.builder(
            padding: const EdgeInsets.fromLTRB(25, 16, 25, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 240,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final p = items[i];
              return InkWell(
                onTap: () => context.goNamed('product', pathParameters: {'id': p.id}),
                child: ProductCard(product: p),
              );
            },
          ),
        );
        },
    );
  }
}