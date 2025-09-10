// lib/pages/products_page.dart
import 'package:first_app/pages/cart_page/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:first_app/api/server_api.dart';
import 'package:first_app/api/response/products_response.dart';
import 'package:first_app/models/catalog_models.dart';
import 'package:first_app/widgets/product_card.dart';
import 'package:first_app/models/product_short.dart';



class ProductsPage extends StatefulWidget {
  static String path = "/products";
  const ProductsPage({
    super.key,
    this.categoryId,
    this.section,
    this.showSearch = false,
    this.title,
  });

  final String? categoryId;
  final String? section;
  final bool showSearch;
  final String? title;


  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _api = ServerApi();
  final _searchC = TextEditingController();


  late Future<ProductsResponse> future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    future = _load();
  }

  @override
  void didUpdateWidget(covariant ProductsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId ||
        oldWidget.section != widget.section) {
      future = _load();
      setState(() {});
    }
  }


  Future<ProductsResponse> _load() {
    return _api.getProducts(
      categoryId: widget.categoryId,
      query: _query,
    );
  }

  void _doSearch() {
    setState(() {
      _query = _searchC.text.trim();
      future = _load();
    });
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
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
          id: p.id,
          title: p.title,
          imageUrl: p.imageUrl,
          price: p.price,
        );
        // CartData.of(ctx).addProduct(short);
        context.read<CartBloc>().add(CartAdd(short));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.categoryId != null
        ? widget.title.toString()
        : 'Products';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          if (widget.showSearch) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchC,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _doSearch(),
                decoration: InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _doSearch,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF2F3F2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],

          Expanded(
            child: FutureBuilder<ProductsResponse>(
              future: future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }

                final res = snap.data!;
                if (!res.isSuccess) {
                  return Center(child: Text(res.message.isEmpty ? 'Failed to load' : res.message));
                }

                final items = res.items;
                if (items.isEmpty) {
                  return const Center(child: Text('No products'));
                }

                return GridView.builder(
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
