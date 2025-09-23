import 'package:first_app/pages/legal_pages/legal_pages.dart';
import 'package:first_app/pages/order_accepted_page/order_accepted_page.dart';
import 'package:first_app/pages/orders_page/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:first_app/utils/app_settings.dart';


import 'package:first_app/pages/intro_page/intro_page.dart';
import 'package:first_app/pages/login_page/login_page.dart';
import 'package:first_app/pages/signup_page/signup.dart';
import 'package:first_app/pages/home_page/home_page.dart';
import 'package:first_app/pages/categories_page/categories_page.dart';
import 'package:first_app/pages/products_page/products_page.dart';
import 'package:first_app/pages/cart_page/cart_page.dart';
import 'package:first_app/pages/favourites_page/favourites_page.dart';
import 'package:first_app/pages/account_page/account_page.dart';
import 'package:first_app/models/catalog_models.dart';
import 'package:first_app/widgets/product_loader.dart';
import 'package:first_app/pages/app/app_main_menu.dart';
import 'package:flutter_svg/flutter_svg.dart';

GoRouter createRouter() {
  return GoRouter(
    refreshListenable: AppSettings.getInstance(),
    initialLocation: '/',
    routes: [

      GoRoute(
        path: '/',
        redirect: (context, state) {
          final s = AppSettings.getInstance();
          final token = s.getToken();
          final seenIntro = s.getSeenIntro();


          if (token.isNotEmpty) return HomePage.path;


          if (!seenIntro) return IntroPage.path;


          return LoginPage.path;
        },
      ),


      GoRoute(
        path: IntroPage.path, // '/intro'
        name: 'intro',
        builder: (_, __) => const IntroPage(),
      ),
      GoRoute(
          path: LoginPage.path,
          name: 'login',
          builder: (_, __) => const LoginPage()
      ),
      GoRoute(
          path: SignUpPage.path,
          name: 'signup',
          builder: (_, __) => const SignUpPage()
      ),
      GoRoute(
        path: '/order/accepted',
        name: 'orderAccepted',
        builder: (_, state) {
          final extra = (state.extra is Map) ? state.extra as Map : const {};
          final int? orderId = extra['orderId'] as int?;
          final double total = (extra['total'] as double?) ?? 0;
          return OrderAcceptedPage(orderId: orderId, total: total);
        },
      ),
      GoRoute(
        path: '/legal/terms',
        name: 'terms',
        builder: (_, __) => TermsPage(),
      ),
      GoRoute(
        path: '/legal/conditions',
        name: 'conditions',
        builder: (_, __) => ConditionsPage(),
      ),


      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _HomeShell(navigationShell: navigationShell),
        branches: [

          StatefulShellBranch(routes: [
            GoRoute(
                path: HomePage.path,
                name: 'home',
                builder: (_, __) => const HomePage()
            ),
          ]),


          StatefulShellBranch(routes: [
            GoRoute(
              path: '/explore',
              name: 'explore',
              builder: (_, __) => const CategoriesPage(showSearch: true),
              routes: [
                GoRoute(
                    path: 'products',
                    name: 'products',
                    builder: (_, __) => const ProductsPage()
                ),
                GoRoute(
                  path: 'category/:id',
                  name: 'categoryProducts',
                  builder: (_, state) => ProductsPage(
                    key: ValueKey('cat-${state.pathParameters['id']}'),
                    categoryId: state.pathParameters['id']!,
                    title: state.extra is String ? state.extra as String : null,
                  ),
                ),
                GoRoute(
                  path: 'section/:kind',
                  name: 'sectionProducts',
                  builder: (_, state) => ProductsPage(section: state.pathParameters['kind']!),
                ),
                GoRoute(
                  path: 'search',
                  name: 'productsSearch',
                  builder: (_, __) => const ProductsPage(showSearch: true),
                ),
                GoRoute(
                  path: 'product/:id',
                  name: 'product',
                  builder: (_, state) {
                    final id = state.pathParameters['id']!;
                    final ProductItem? preview =
                    state.extra is ProductItem ? state.extra as ProductItem : null;
                    return ProductLoader(id: id, preview: preview);
                  },
                ),
              ],
            ),
          ]),


          StatefulShellBranch(routes: [
            GoRoute(
                path: '/cart',
                name: 'cart',
                builder: (_, __) => const CartPage()
            ),
          ]),


          StatefulShellBranch(routes: [
            GoRoute(
                path: '/favourites',
                name: 'favourites',
                builder: (_, __) => const FavouritesPage()
            ),
          ]),


          StatefulShellBranch(routes: [
            GoRoute(
              path: '/account',
              name: 'account',
              builder: (_, __) => const AccountPage(),
              redirect: (context, state) {
                final token = AppSettings.getInstance().getToken();
                return token.isEmpty ? '/login' : null;
              },
              routes: [
                GoRoute(
                  path: 'orders',
                  name: 'orders',
                  builder: (_, __) => const OrdersPage(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
}


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
    colorFilter: ColorFilter.mode(active ? kActive : kInactive, BlendMode.srcIn),
  );

  @override
  Widget build(BuildContext context) {
    final idx = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: AppMainMenu(
          currentIndex: idx,
          onTap: (i) {
            final token = AppSettings.getInstance().getToken();
            if (i == 4 && token.isEmpty) {
              context.go('/login');
              return;
            }
            navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex);
          },
        ),
      ),
    );
  }
}
