import 'package:flutter/material.dart';
import '../models/catalog_models.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = <ProductItem>[
      ProductItem(
        title: 'Organic Bananas',
        subtitle: '7pcs, Price',
        imageUrl: 'https://i.postimg.cc/3xg7W7z8/92f1ea7dcce3b5d06cd1b1418f9b9413-3.png',
        price: 4.99,
        onAdd: () => debugPrint('Add Bananas'),
      ),
      ProductItem(
        title: 'Red Apple',
        subtitle: '1kg, Price',
        imageUrl: 'https://i.postimg.cc/sgFsV16H/pngfuel-2.png',
        price: 4.99,
        onAdd: () => debugPrint('Add Apple'),
      ),
      ProductItem(
        title: 'Bell Pepper Red',
        subtitle: '1kg, Price',
        imageUrl: 'https://i.postimg.cc/GpmcfVSb/92f1ea7dcce3b5d06cd1b1418f9b9413-3-1.png',
        price: 4.99,
        onAdd: () => debugPrint('Add Pepper'),
      ),
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
            const _SectionHeader(title: 'Exclusive Offer'),
            SizedBox(
              height: 250,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (_, i) => ProductCard(product: products[i]),
              ),
            ),
            const SizedBox(height: 12),
            const _SectionHeader(title: 'Groceries'),
            SizedBox(
              height: 120,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF53B175)),
            child: const Text('See all'),
          ),
        ],
      ),
    );
  }
}
