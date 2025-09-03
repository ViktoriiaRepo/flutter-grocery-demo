import 'package:first_app/utils/colors.dart';
import 'package:first_app/widgets/cart_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppMainMenu extends StatelessWidget {
  const AppMainMenu({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    Widget item(String title, String asset, int idx, {bool withBadge = false}) {
      final active = idx == currentIndex;

      final icon = Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            'assets/$asset.svg',
            width: 25,
            height: 25,
            colorFilter: ColorFilter.mode(
              active ? const Color(0xFF53B175) : const Color(0xFF181725),
              BlendMode.srcIn,
            ),
          ),
          if (withBadge)
            const Positioned(
              right: -8,
              top: -6,

              child: CartCounterBadge(),
            ),
        ],
      );

      return InkWell(
        onTap: () => onTap(idx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? const Color(0xFF53B175) : const Color(0xFF181725),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          item('Shop',      'shop',     0),
          item('Explore',   'explore',  1),
          item('Cart',      'cart',     2, withBadge: true),
          item('Favourite', 'fav',      3),
          item('Account',   'account',  4),
        ],
      ),
    );
  }
}
