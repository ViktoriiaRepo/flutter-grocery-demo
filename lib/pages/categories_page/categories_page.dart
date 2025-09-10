import 'package:first_app/api/server_api.dart';
import 'package:first_app/api/response/products_response.dart';
import 'package:first_app/models/catalog_models.dart';
import 'package:first_app/models/product_short.dart';
import 'package:first_app/pages/cart_page/bloc/cart_bloc.dart';
import 'package:first_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/explore_category_card.dart';

class CategoriesPage extends StatefulWidget {
  static const String path = '/explore';
  const CategoriesPage({super.key, this.showSearch = true});
  final bool showSearch;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _api = ServerApi();

  late Future<List<ApiCategory>> _catsFuture;
  Future<ProductsResponse>? _productsF;

  final _searchC = TextEditingController();
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
  void initState() {
    super.initState();
    _catsFuture = _api.fetchCategories();
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  void _onQueryChanged(String v) {
    setState(() {
      _query = v.trim();
      if (_query.isEmpty) {
        _productsF = null;
      } else {
        _productsF = _api.getProducts(query: _query);
      }
    });
  }

  void _clearQuery() {
    setState(() {
      _searchC.clear();
    });
    _onQueryChanged('');
  }

  ProductItem _withAdd(BuildContext ctx, ProductItem p) {
    return ProductItem(
      id: p.id,
      title: p.title,
      subtitle: p.subtitle,
      imageUrl: p.imageUrl,
      category: p.category,
      price: p.price,
      section: p.section,
      description: p.description,
      nutritions: p.nutritions,
      onAdd: () {
        final short = ProductShort(
          id: p.id, title: p.title, imageUrl: p.imageUrl, price: p.price,
        );
        ctx.read<CartBloc>().add(CartAdd(short));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(_query.isEmpty ? 'Find Products' : ''),
      ),
      body: Column(
        children: [
          if (widget.showSearch)
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
              child: TextField(
                controller: _searchC,
                onChanged: _onQueryChanged,
                onSubmitted: _onQueryChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search Store',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                    tooltip: 'Clear',
                    onPressed: _clearQuery,
                    icon: const Icon(Icons.close),
                  ),
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
            child: _query.isEmpty
                ? FutureBuilder<List<ApiCategory>>(
              future: _catsFuture,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }

                final cats = snap.data ?? const <ApiCategory>[];
                if (cats.isEmpty) {
                  return const Center(child: Text('No categories'));
                }

                return GridView.builder(
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
                      imageUrl: c.iconUrl,
                      background: _palette[i % _palette.length],
                      onTap: () => context.goNamed(
                        'categoryProducts',
                        pathParameters: {'id': c.id.toString()},
                        extra: c.title,
                      ),
                    );
                  },
                );
              },
            )
                : FutureBuilder<ProductsResponse>(
              future: _productsF,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }

                final res = snap.data!;
                if (!res.isSuccess) {
                  return Center(
                    child: Text(res.message.isEmpty ? 'Failed to load' : res.message),
                  );
                }

                final items = res.items;
                if (items.isEmpty) {
                  return const Center(child: Text('No results'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(25, 8, 25, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 240,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final p = items[i];
                    final ui = _withAdd(context, p);
                    return InkWell(
                      onTap: () => context.pushNamed(
                        'product',
                        pathParameters: {'id': p.id},
                        extra: ui,
                      ),
                      child: ProductCard(product: ui),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
