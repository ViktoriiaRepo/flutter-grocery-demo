import 'package:first_app/pages/app/app_main_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AppMenuPage extends StatelessWidget {
  final Widget child;
  const AppMenuPage({super.key, required this.child});

  static const _paths = <String>['/', '/explore', '/cart', '/favourites', '/account'];

  int _indexFromLocation(String loc) {
    if (loc == '/' || loc.startsWith('/?')) return 0;
    if (loc.startsWith('/explore')) return 1;
    if (loc.startsWith('/cart')) return 2;
    if (loc.startsWith('/favourites')) return 3;
    if (loc.startsWith('/account')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final info = GoRouter.of(context).routeInformationProvider.value;
    final location = info.location ?? '/';
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const SizedBox.shrink(),
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset('assets/shop.svg', width: 28),
        ),
      ),
      body: child,
      bottomNavigationBar: AppMainMenu(
        currentIndex: currentIndex,
        onTap: (i) => GoRouter.of(context).go(_paths[i]),
      ),
    );
  }
}
