import 'package:first_app/pages/cart_page/bloc/cart_bloc.dart';
import 'package:first_app/pages/favourites_page/cubit/favourites_cubit.dart';
import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FavouritesPage extends StatelessWidget {
  static const String path = '/favourites';
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text('Favourite',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          )
      ),
      body: BlocBuilder<FavouritesCubit, FavouritesState>(
        builder: (context, state) {
          final items = state.list;
          if (items.isEmpty) {
            return const Center(child: Text('No favourites yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final fp = items[i];
              final p = fp.product;

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 48, width: 48,
                    child: p.imageUrl.isNotEmpty
                        ? Image.network(p.imageUrl, fit: BoxFit.contain)
                        : Container(color: const Color(0xFFF3F4F6)),
                  ),
                ),
                title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: const Text('Price, per item', style: TextStyle(color: Colors.black54)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('\$${p.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: Colors.black45),
                      onPressed: () => context.read<FavouritesCubit>().remove(p.id.toString()),
                    ),
                  ],
                ),
                onTap: () => context.push('/product/${p.id}'),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<FavouritesCubit, FavouritesState>(
        builder: (context, state) {
          if (state.list.isEmpty) return const SizedBox.shrink();
          return SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  final cart = context.read<CartBloc>();
                  for (final fp in state.list) {
                    cart.add(CartAdd(fp.product));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All favourites added to cart')),
                  );
                },
                child: const Text('Add All To Cart',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          );
        },
      ),
    );
  }
}
