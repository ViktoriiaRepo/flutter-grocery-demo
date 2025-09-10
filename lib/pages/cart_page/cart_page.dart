import 'package:first_app/pages/cart_page/widgets/checkout_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_app/pages/cart_page/bloc/cart_bloc.dart';
import 'package:first_app/utils/colors.dart';

class CartPage extends StatelessWidget {
  static const String path = '/cart';
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text('My Cart', style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),)
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final items = state.products;
          if (items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final cp = items[i];
              final p = cp.product;
              final lineTotal = cp.count * p.price;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 56, width: 56,
                        child: p.imageUrl.isNotEmpty
                            ? Image.network(p.imageUrl, fit: BoxFit.contain)
                            : Container(color: const Color(0xFFF3F4F6)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.title, style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(height: 2),
                          const Text('Price, per item',
                              style: TextStyle(color: AppColor.descColor, fontSize: 12)),
                          const SizedBox(height: 8),
                          _Qty(id: p.id.toString(), count: cp.count),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, size: 20, color: AppColor.descColor),
                          onPressed: () => context.read<CartBloc>().add(CartRemove(p.id.toString())),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(height: 4),
                        Text('\$${lineTotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.products.isEmpty) return const SizedBox.shrink();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const CheckoutSheet(),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Go to Checkout',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0x1AFFFFFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '\$${state.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Qty extends StatelessWidget {
  final String id;
  final int count;
  const _Qty({required this.id, required this.count});

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData icon, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E2E2)),
          ),
          child: Icon(icon, size: 18),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn(Icons.remove, () => context.read<CartBloc>().add(CartDecrement(id))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('$count', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ),
        btn(Icons.add, () => context.read<CartBloc>().add(CartIncrement(id))),
      ],
    );
  }
}
