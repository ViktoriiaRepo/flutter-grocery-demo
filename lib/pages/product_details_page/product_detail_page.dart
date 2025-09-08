// lib/pages/product_detail_page.dart
import 'package:first_app/models/product_short.dart';
import 'package:first_app/pages/cart_page/bloc/cart_bloc.dart';
import 'package:first_app/pages/favourites_page/cubit/favourites_cubit.dart';

import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/catalog_models.dart';
import 'package:go_router/go_router.dart';


class ProductDetailPage extends StatefulWidget {
  final ProductItem product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(

      body: CustomScrollView(

        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {

                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            ),
            actions: [
              BlocBuilder<FavouritesCubit, FavouritesState>(
                buildWhen: (prev, next) => prev.isFav(p.id) != next.isFav(p.id),
                builder: (context, state) {
                  final isFav = state.isFav(p.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : null,
                    ),
                    onPressed: () {
                      final short = ProductShort(
                        id: p.id, title: p.title, imageUrl: p.imageUrl, price: p.price,
                      );
                      context.read<FavouritesCubit>().toggle(short);
                    },
                  );
                },
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFFF8F8F8),
                child: Padding(
                    padding:EdgeInsets.only(top: 70,bottom:30),
                child: Center(
                  child: Image.network(
                    p.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 64),
                  ),
                ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 16, 25, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(p.subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                  const SizedBox(height: 16),

                  // qty + price
                  Row(
                    children: [
                      _QtyPicker(
                        value: qty,
                        onChanged: (v) => setState(() => qty = v),
                      ),
                      const Spacer(),
                      Text('\$${p.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Product Detail
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      initiallyExpanded: true,
                      title: const Text('Product Detail',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          p.description ?? 'No description provided.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (p.nutritions.isNotEmpty)
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: const Text('Nutritions',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        children: [
                          const SizedBox(height: 8),
                          ...p.nutritions.entries.map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(child: Text(e.key)),
                                Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(25, 8, 25, 16),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.accentColor ,
              foregroundColor: AppColor.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
            ),
            onPressed: () {
              final p = widget.product;

              final short = ProductShort(
                id: p.id,
                title: p.title,
                imageUrl: p.imageUrl,
                price: p.price,
              );

              // final cart = CartData.of(context);
              final cart = context.read<CartBloc>();
              for (var i = 0; i < qty; i++) {
                // cart.addProduct(short);
                cart.add(CartAdd(short));
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added ${p.title} ×$qty to cart')),
              );


            },
            child: const Text('Add To Basket'),
          ),
        ),
      ),
    );
  }
}

class _QtyPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _QtyPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove),
          ),
          Text('$value', style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => onChanged(value + 1),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
