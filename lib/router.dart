import 'package:first_app/pages/products_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'pages/shop_page.dart';
import 'pages/categories_page.dart';
import 'pages/cart_page.dart';
import 'pages/favourites_page.dart';
import 'pages/account_page.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'catalog_data.dart';
import 'pages/product_detail_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (_, __) => const SignUpPage(),
    ),


    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _HomeShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/', name: 'shop', builder: (_, __) => const ShopPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/explore',
              name: 'explore',
              builder: (_, __) => const CategoriesPage(showSearch: true),
            routes: [
              GoRoute(
                path: 'category/:id',
                name: 'categoryProducts',
                builder: (_, state) => ProductsPage(categoryId: state.pathParameters['id']!),
              ),
              GoRoute(
                path: 'products',
                name: 'products',
                builder: (_, __) => const ProductsPage(),
              ),

              GoRoute(
                path: 'section/:kind',
                name: 'sectionProducts',
                builder: (_, state) =>
                    ProductsPage(section: state.pathParameters['kind']!),
              ),
              GoRoute(
                path: 'search',
                name: 'productsSearch',
                builder: (_, __) => const ProductsPage(showSearch: true),
              ),
              GoRoute(
                path: '/product/:id',
                name: 'product',
                builder: (_, state) {
                  final id = state.pathParameters['id']!;
                  return FutureBuilder(
                    future: CatalogData.ensureLoaded(),
                    builder: (context, snap) {
                      if (snap.connectionState != ConnectionState.done) {
                        return const Scaffold(body: Center(child: CircularProgressIndicator()));
                      }
                      final product = CatalogData.getById(id);
                      return ProductDetailPage(product: product);
                    },
                  );
                },
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/cart', name: 'cart', builder: (_, __) => const CartPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/favourites', name: 'favourites', builder: (_, __) => const FavouritesPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/account', name: 'account', builder: (_, __) => const AccountPage()),
        ]),
      ],
    ),
  ],
);

class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  static const kActive = Color(0xFF53B175);
  static const kInactive = Color(0xFF181725);

  void _onTap(int i) {
    navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex);
  }

  Widget _icon(String asset, bool active) => SvgPicture.asset(
    'assets/$asset.svg',
    width: 26,
    height: 26,
    colorFilter: ColorFilter.mode(
      active ? kActive : kInactive,
      BlendMode.srcIn,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final idx = navigationShell.currentIndex;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x17555E58),
                offset: Offset(2, -5),
                blurRadius: 15,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                elevation: 0,
                currentIndex: idx,
                onTap: _onTap,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: kActive,
                unselectedItemColor: kInactive,
                showUnselectedLabels: true,
                items: [
                  BottomNavigationBarItem(icon: _icon('shop',     idx == 0), label: 'Shop'),
                  BottomNavigationBarItem(icon: _icon('explore',  idx == 1), label: 'Explore'),
                  BottomNavigationBarItem(icon: _icon('cart',     idx == 2), label: 'Cart'),
                  BottomNavigationBarItem(icon: _icon('fav',      idx == 3), label: 'Favourite'),
                  BottomNavigationBarItem(icon: _icon('account',  idx == 4), label: 'Account'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
