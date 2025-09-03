import 'package:first_app/pages/cart_page/cart_data.dart';
import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';

class CartCounterBadge extends StatelessWidget {
  const CartCounterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final data = CartData.of(context);

    final total = data.products.fold<int>(0, (sum, p) => sum + p.count);

    if (total <= 0) return const SizedBox.shrink();

    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$total',
        style: const TextStyle(color: AppColor.white, fontSize: 10, height: 1),
      ),
    );
  }
}
