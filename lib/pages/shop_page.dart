import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    final exclusive = <ProductItem>[
      ProductItem(
        title: 'Organic Bananas',
        subtitle: '7pcs, Price',
        imageUrl: 'https://i.postimg.cc/3xg7W7z8/92f1ea7dcce3b5d06cd1b1418f9b9413-3.png',
        category: 'fruits',
        price: 4.99,
        onAdd: () => debugPrint('Add Bananas'),
      ),
      ProductItem(
        title: 'Red Apple',
        subtitle: '1kg, Price',
        imageUrl: 'https://i.postimg.cc/sgFsV16H/pngfuel-2.png',
        category: 'fruits',
        price: 4.99,
        onAdd: () => debugPrint('Add Apple'),
      ),
      ProductItem(
        title: 'Red Apple',
        subtitle: '1kg, Price',
        imageUrl: 'https://i.postimg.cc/sgFsV16H/pngfuel-2.png',
        category: 'fruits',
        price: 4.99,
        onAdd: () => debugPrint('Add Apple'),
      ),
    ];

    final bestSelling = <ProductItem>[
      ProductItem(
        title: 'Bell Pepper Red',
        subtitle: '1kg, Price',
        imageUrl: 'https://i.postimg.cc/GpmcfVSb/92f1ea7dcce3b5d06cd1b1418f9b9413-3-1.png',
        category: 'fruits',
        price: 4.99,
        onAdd: () => debugPrint('Add Pepper'),
      ),
      ProductItem(
        title: 'Ginger',
        subtitle: '250gm, Price',
        imageUrl: 'https://i.postimg.cc/jd9dgMKJ/pngfuel-3.png',
        category: 'fruits',
        price: 4.99,
        onAdd: () => debugPrint('Add Pepper'),
      ),
      ProductItem(
        title: 'Ginger',
        subtitle: '250gm, Price',
        imageUrl: 'https://i.postimg.cc/jd9dgMKJ/pngfuel-3.png',
        category: 'fruits',
        price: 4.99,
        onAdd: () => debugPrint('Add Pepper'),
      )
    ];

    final sections = <ProductSection>[

      ProductSection('exclusive', 'Exclusive Offer', exclusive),
      ProductSection('best', 'Best Selling', bestSelling),
    ];

    final categories = <CategoryItem>[
      CategoryItem(
        title: 'Pulses',
        imageUrl: 'https://i.postimg.cc/fbp6vrG2/4215936-pulses-png-8-png-image-pulses-png-409-409-1.png',
        background: const Color(0xFFFFF1E6),
        onTap: () => debugPrint('Open Pulses'),
      ),
      CategoryItem(
        title: 'Rice',
        imageUrl: 'https://i.postimg.cc/HLVqXgh8/8-82858-download-sack-of-rice-png-1.png',
        background: const Color(0xFFE9F7F1),
        onTap: () => debugPrint('Open Rice'),
      ),
    ];

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: _SearchInput(),
            ),
            SizedBox(height: 20),
            HomeBanner(),
            SizedBox(height: 30),
            for (final s in sections) ...[
              _ProductsSection(title: s.title, items: s.items,sectionKey: s.key ),
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
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) => CategoryCard(category: categories[i]),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
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
            itemBuilder: (_, i) => SizedBox(
              width: 170,
              child: ProductCard(product: items[i]),
            ),
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
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

