// lib/pages/categories_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../catalog_data.dart';
import '../widgets/explore_category_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key, this.showSearch = true});
  final bool showSearch;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String _query = '';

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
    return FutureBuilder(
      future: CatalogData.ensureLoaded(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
        }

        final cats = CatalogData.searchCategories(_query);

        return Scaffold(
          appBar: AppBar(title: const Text('Find Products')),
          body: Column(
            children: [
              if (widget.showSearch)
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                  child: TextField(
                    onChanged: (v) {
                      debugPrint('changed: $v');
                      setState(() => _query = v);
                    },
                    onSubmitted: (v) => debugPrint('submitted: $v'),
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
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(25, 8, 25, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 190,
                  ),
                  itemCount: cats.length,
                  itemBuilder: (_, i) {
                    final c = cats[i];
                    return ExploreCategoryCard(
                      title: c.title,
                      imageUrl: c.imageUrl,
                      background: _palette[i % _palette.length],
                      onTap: () => context.goNamed(
                        'categoryProducts',
                        pathParameters: {'id': c.id},
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
