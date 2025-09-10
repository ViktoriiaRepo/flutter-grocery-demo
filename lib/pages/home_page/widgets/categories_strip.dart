import 'package:first_app/api/server_api.dart';
import 'package:first_app/models/catalog_models.dart';
import 'package:first_app/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoriesStrip extends StatelessWidget {
  const CategoriesStrip({super.key});

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
    final api = ServerApi();

    return FutureBuilder<List<ApiCategory>>(
      future: api.fetchCategories(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) return const SizedBox.shrink();

        final cats = snap.data ?? const <ApiCategory>[];
        if (cats.isEmpty) return const SizedBox.shrink();

        const hPad = 25.0;
        const gap = 8.0;
        final screenW = MediaQuery.of(context).size.width;
        final available = screenW - hPad * 2;
        final cardW = (available - gap) / 1.5;

        return SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: hPad),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: cats.length,
            separatorBuilder: (_, __) => const SizedBox(width: gap),
            itemBuilder: (_, i) {
              final c = cats[i];
              final item = CategoryItem(
                title: c.title,
                imageUrl: c.iconUrl,
                background: _palette[i % _palette.length],
                onTap: () => context.goNamed(
                  'categoryProducts',
                  pathParameters: {'id': c.id.toString()},
                  extra: c.title,
                ),
              );
              return SizedBox(
                width: cardW,
                child: CategoryCard(category: item),
              );
            },
          ),
        );
      },
    );
  }
}
