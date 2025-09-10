import 'package:first_app/api/response/home_response.dart';
import 'package:first_app/api/server_api.dart';
import 'package:first_app/models/product_short.dart';
import 'package:first_app/pages/cart_page/bloc/cart_bloc.dart';
import 'package:first_app/pages/home_page/widgets/search_suggest_input.dart';
import 'package:first_app/pages/home_page/widgets/section_header.dart';
import 'package:first_app/pages/home_page/widgets/products_section.dart';
import 'package:first_app/pages/home_page/widgets/categories_strip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../models/catalog_models.dart';
import '../../widgets/home_banner.dart';

class ProductSection {
  final String key;
  final String title;
  final List<ProductItem> items;
  const ProductSection(this.key, this.title, this.items);
}

class HomePage extends StatelessWidget {
  static const String path = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ServerApi();

    return FutureBuilder<HomeResponse>(
      future: api.loadHome(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
        }

        final res = snap.data!;
        ProductItem toUi(HomeProduct p) => ProductItem(
          id: p.id,
          title: p.name,
          subtitle: p.shortDescription,
          imageUrl: p.imageUrl,
          price: p.price,
          category: '',
          section: null,
          description: null,
          nutritions: const {},
          onAdd: () {
            final short = ProductShort(
              id: p.id,
              title: p.name,
              imageUrl: p.imageUrl,
              price: p.price,
            );
            context.read<CartBloc>().add(CartAdd(short));
          },
        );

        final sections = <ProductSection>[
          ProductSection('exclusive', 'Exclusive Offer', res.exclusive.map(toUi).toList()),
          ProductSection('best', 'Best Selling', res.best.map(toUi).toList()),
        ];

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 54),
                SvgPicture.asset('assets/carrot.svg', width: 28),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SearchSuggestInput(
                    fetch: (q) async {
                      final res = await ServerApi().getProducts(query: q);
                      return res.items.map<SuggestProduct>((p) => SuggestProduct(
                        id: p.id.toString(),
                        title: (p.title ?? '').toString(),
                        imageUrl: (p.imageUrl ?? '').toString(),
                        price: (p.price ?? 0).toDouble(),
                      )).toList();
                    },
                  ),
                ),

                const SizedBox(height: 20),
                HomeBanner(images: res.slider),
                const SizedBox(height: 30),

                for (final s in sections) ...[
                  ProductsSection(title: s.title, items: s.items, sectionKey: s.key),
                  const SizedBox(height: 12),
                ],

                SectionHeader(
                  title: 'Categories',
                  onSeeAll: () => context.goNamed('explore'),
                ),
                const CategoriesStrip(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
