import 'package:first_app/models/catalog_models.dart';
import 'package:first_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'section_header.dart';

class ProductsSection extends StatelessWidget {
  final String title;
  final String sectionKey;
  final List<ProductItem> items;

  const ProductsSection({
    super.key,
    required this.title,
    required this.items,
    required this.sectionKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          onSeeAll: () => context.goNamed(
            'sectionProducts',
            pathParameters: {'kind': sectionKey},
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) {
              final p = items[i];
              return SizedBox(
                width: 170,
                child: InkWell(
                  onTap: () => context.pushNamed(
                    'product',
                    pathParameters: {'id': p.id},
                    extra: p,
                  ),
                  child: ProductCard(product: p),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
