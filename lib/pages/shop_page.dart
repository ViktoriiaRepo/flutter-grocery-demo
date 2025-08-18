import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../catalog_data.dart';
import '../models/catalog_models.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import '../widgets/home_banner.dart';

class ProductSection {
  final String key;
  final String title;
  final List<ProductItem> items;
  const ProductSection(this.key, this.title, this.items);
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  static const _palette = <Color>[
    Color(0xFFFFF1E6),
    Color(0xFFE9F7F1),
    Color(0xFFF4EBF7),
    Color(0xFFFFF4E5),
    Color(0xFFEFF6FF),
    Color(0xFFF3F4F6),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: CatalogData.ensureLoaded(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
        }

        final sections = <ProductSection>[
          ProductSection('exclusive', 'Exclusive Offer',
              CatalogData.exclusive /*.take(6)*/ .toList()),
          ProductSection('best', 'Best Selling',
              CatalogData.bestSelling /*.take(6)*/ .toList()),
        ];


        final cats = CatalogData.categories;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Groceries'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: _SearchInput(),
                ),
                const SizedBox(height: 20),
                HomeBanner(),
                const SizedBox(height: 30),

                for (final s in sections) ...[
                  _ProductsSection(
                    title: s.title,
                    items: s.items,
                    sectionKey: s.key,
                  ),
                  const SizedBox(height: 12),
                ],

                _SectionHeader(
                  title: 'Categories',
                  onSeeAll: () => context.goNamed('explore'),
                ),

                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    scrollDirection: Axis.horizontal,
                    itemCount: cats.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (_, i) {
                      final c = cats[i];

                      final item = CategoryItem(
                        title: c.title,
                        imageUrl: c.imageUrl,
                        background: _palette[i % _palette.length],
                        onTap: () => context.goNamed(
                          'categoryProducts',
                          pathParameters: {'id': c.id},
                        ),
                      );
                      return SizedBox(
                        width: 170,
                        child: CategoryCard(category: item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductsSection extends StatelessWidget {
  final String title;
  final String sectionKey;
  final List<ProductItem> items;

  const _ProductsSection({
    required this.title,
    required this.items,
    required this.sectionKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
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
                  onTap: () =>
                      context.goNamed('product', pathParameters: {'id': p.id}),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionHeader({required this.title, this.onSeeAll, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 25, right: 25, bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF53B175)),
            child: const Text('See all'),
          ),
        ],
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (v) => debugPrint('search: $v'),
      onSubmitted: (v) => debugPrint('submit: $v'),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search Store',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: const Color(0xFFF2F3F2),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
