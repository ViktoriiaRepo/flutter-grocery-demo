import 'package:first_app/api/response/home_response.dart';
import 'package:first_app/api/server_api.dart';
import 'package:first_app/models/product_short.dart';
import 'package:first_app/pages/cart_page/bloc/cart_bloc.dart';
import 'package:first_app/pages/home_page/widgets/search_suggest_input.dart';
import 'package:first_app/pages/home_page/widgets/section_header.dart';
import 'package:first_app/pages/home_page/widgets/products_section.dart';
import 'package:first_app/pages/home_page/widgets/categories_strip.dart';
import 'package:first_app/widgets/home_banner.dart';
import 'package:first_app/models/catalog_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  static const String path = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ServerApi _api = ServerApi();
  late Future<HomeResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.loadHome();
  }

  Future<void> _reload() async {
    setState(() {
      _future = _api.loadHome();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeResponse>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
        }

        final res = snap.data!;
        if (!res.isSuccess) {
          return Scaffold(
            body: Center(
              child: Text(res.message.isEmpty ? 'Failed to load home' : res.message),
            ),
          );
        }

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

        final exclusiveItems = res.exclusive.map(toUi).toList();
        final bestItems      = res.best.map(toUi).toList();

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _reload,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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

                  ProductsSection(
                    sectionKey: 'exclusive',
                    title: 'Exclusive Offer',
                    items: exclusiveItems,
                  ),
                  const SizedBox(height: 12),
                  ProductsSection(
                    sectionKey: 'best',
                    title: 'Best Selling',
                    items: bestItems,
                  ),
                  const SizedBox(height: 12),

                  SectionHeader(
                    title: 'Categories',
                    onSeeAll: () => context.goNamed('explore'),
                  ),
                  const CategoriesStrip(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
