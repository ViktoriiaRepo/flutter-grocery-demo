import 'package:flutter/material.dart';
import 'package:first_app/pages/favourites_page/favourites_data.dart';
import 'package:first_app/utils/colors.dart';

class FavouritesCounterBadge extends StatelessWidget {
  const FavouritesCounterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = FavouritesData.of(context);
    final count = fav.products.length;

    if (count == 0) return const SizedBox.shrink();

    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$count',
          style: const TextStyle(
            color: AppColor.white,
            fontSize: 10,
            height: 1,
          ),
        ),
      ),
    );
  }
}
