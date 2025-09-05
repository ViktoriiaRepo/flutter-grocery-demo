// lib/pages/favourites_page/favourites_page.dart
import 'package:first_app/pages/cart_page/cart_data.dart';
import 'package:first_app/pages/favourites_page/favourites_data.dart';
import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavouritesPage extends StatelessWidget {
  static const String path = '/favourites';
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = FavouritesData.of(context);
    final cart = CartData.of(context);
    final items = fav.products;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Favourite')),
      body: items.isEmpty
          ? const Center(child: Text('No favourites yet'))
          : ListView.separated(
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
                    ? Image.network(p.imageUrl, fit: BoxFit.cover)
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
                  onPressed: () => fav.remove(p.id.toString()),
                ),
              ],
            ),
            onTap: () {
              context.push('/product/${p.id}');
            },
          );
        },
      ),
      bottomNavigationBar: items.isEmpty
          ? null
          : SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              for (final fp in items) {
                cart.addProduct(fp.product);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All favourites added to cart')),
              );
            },
            child: const Text('Add All To Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}
