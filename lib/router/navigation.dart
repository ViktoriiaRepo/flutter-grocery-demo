import 'package:first_app/models/catalog_models.dart';
import 'package:first_app/pages/account_page/account_page.dart';
import 'package:first_app/pages/cart_page/cart_page.dart';
import 'package:first_app/pages/favourites_page/favourites_page.dart';
import 'package:first_app/pages/home_page/shop_page.dart';
import 'package:first_app/pages/intro_page/intro_page.dart';
import 'package:first_app/pages/login_page/login_page.dart';
import 'package:first_app/pages/categories_page/categories_page.dart';
import 'package:first_app/pages/products_page/products_page.dart';

import 'package:first_app/pages/splash_page/splash_page.dart';
import 'package:first_app/router/app_menu_page.dart';
import 'package:first_app/router/authorized_app.dart';
import 'package:first_app/utils/app_settings.dart';
import 'package:first_app/widgets/product_loader.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  static GoRouter? _router;

  static GoRouter getRouter() {
    return _router ??= GoRouter(
      initialLocation: '/',
      refreshListenable: AppSettings.getInstance(),
      redirect: (context, state) {
        final authed = AppSettings.getInstance().getToken().isNotEmpty;
        final loc = state.matchedLocation;
        final isPublic = (loc == '/' || loc == IntroPage.path || loc == LoginPage.path);
        if (!authed) return isPublic ? null : LoginPage.path;
        if (authed && isPublic) return ShopPage.path;
        return null;
      },
      routes: [

        GoRoute(path: SplashPage.path,               name: 'splash', builder: (_, __) => const SplashPage()),
        GoRoute(path: IntroPage.path,    name: 'intro',  builder: (_, __) => const IntroPage()),
        GoRoute(path: LoginPage.path,    name: 'login',  builder: (_, __) => const LoginPage()),


        ShellRoute(
          builder: (context, state, child) => AuthorizedApp(child: child),
          routes: [

            ShellRoute(
              builder: (context, state, child) => AppMenuPage(child: child),
              routes: [
                GoRoute(
                  path: ShopPage.path,
                  name: 'shop',
                  builder: (_, __) => const ShopPage(),
                ),
                GoRoute(
                  path: CategoriesPage.path,
                  name: 'explore',
                  builder: (_, __) => const CategoriesPage(showSearch: true),
                  routes: [
                    GoRoute(
                      path: 'products',
                      name: 'products',
                      builder: (_, __) => const ProductsPage(),
                    ),
                    GoRoute(
                      path: 'search',
                      name: 'productsSearch',
                      builder: (_, __) => const ProductsPage(showSearch: true),
                    ),
                    GoRoute(
                      path: 'category/:id',
                      name: 'categoryProducts',
                      builder: (_, st) => ProductsPage(categoryId: st.pathParameters['id']!),
                    ),
                    GoRoute(
                      path: 'section/:kind',
                      name: 'sectionProducts',
                      builder: (_, st) => ProductsPage(section: st.pathParameters['kind']!),
                    ),
                  ],
                ),
                GoRoute(
                  path: CartPage.path,
                  name: 'cart',
                  builder: (_, __) => const CartPage(),
                ),
                GoRoute(
                  path: FavouritesPage.path,
                  name: 'favourites',
                  builder: (_, __) => const FavouritesPage(),
                ),
                GoRoute(
                  path: AccountPage.path,
                  name: 'account',
                  builder: (_, __) => const AccountPage(),
                ),
              ],
            ),

            GoRoute(
              path: '/product/:id',
              name: 'product',
              builder: (_, st) {
                final id = st.pathParameters['id']!;
                final preview = st.extra is ProductItem ? st.extra as ProductItem : null;
                return ProductLoader(id: id, preview: preview);
              },
            ),
          ],
        ),
      ],
    );
  }
}
