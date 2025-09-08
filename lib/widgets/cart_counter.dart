import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_app/pages/cart_page/bloc/cart_bloc.dart';
import 'package:first_app/utils/colors.dart';

class CartCounterBadge extends StatelessWidget {
  const CartCounterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartBloc, CartState, int>(
      selector: (s) => s.totalCount,
      builder: (_, total) {
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
      },
    );
  }
}
