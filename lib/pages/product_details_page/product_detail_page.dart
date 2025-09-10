import 'package:first_app/models/product_short.dart';
import 'package:first_app/pages/cart_page/bloc/cart_bloc.dart';
import 'package:first_app/pages/favourites_page/cubit/favourites_cubit.dart';
import 'package:first_app/pages/product_details_page/widgets/product_image_carousel.dart';
import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/catalog_models.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductItem product;
  final List<String>? gallery;
  const ProductDetailPage({super.key, required this.product, this.gallery});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    final inCart = context.select<CartBloc, bool>(
          (bloc) => bloc.state.items.containsKey(p.id.toString()),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            pinned: true,
            expandedHeight: 340,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.canPop() ? context.pop() : context.go('/'),
            ),

            actions: [
              IconButton(
                tooltip: 'Share',
                icon: const Icon(Icons.ios_share),
                onPressed: () {
                  Share.share('Check this product: ${p.title}');
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12), // 👈 твої паддінги
                  child: ProductImageCarousel(
                    images: (widget.gallery != null && widget.gallery!.isNotEmpty)
                        ? widget.gallery!
                        : [p.imageUrl],
                    height:300,
                    viewportFraction: 1,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          p.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      BlocBuilder<FavouritesCubit, FavouritesState>(
                        buildWhen: (a, b) => a.isFav(p.id) != b.isFav(p.id),
                        builder: (context, state) {
                          final isFav = state.isFav(p.id);
                          return IconButton(
                            iconSize: 24,
                            tooltip: isFav ? 'Remove from favourites' : 'Add to favourites',
                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                              color: isFav ? Colors.red : null,
                            onPressed: () {
                              final short = ProductShort(
                                id: p.id,
                                title: p.title,
                                imageUrl: p.imageUrl,
                                price: p.price,
                              );
                              context.read<FavouritesCubit>().toggle(short);
                            },
                          );
                        },
                      ),
                    ],
                  ),


                  if (p.subtitle.isNotEmpty)
                    Text(
                      p.subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black54),
                    ),

                  const SizedBox(height: 16),

                  // qty + price
                  Row(
                    children: [
                      _QtyPicker(
                        value: qty,
                        onChanged: (v) => setState(() => qty = v),
                      ),
                      const Spacer(),
                      Text(
                        '\$${p.price.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Product Detail
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      initiallyExpanded: true,
                      title: const Text(
                        'Product Detail',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          (p.description ?? '').isEmpty
                              ? 'No description provided.'
                              : p.description!,
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
                        title: const Text(
                          'Nutritions',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        children: [
                          const SizedBox(height: 8),
                          ...p.nutritions.entries.map(
                                (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Expanded(child: Text(e.key)),
                                  Text(
                                    e.value,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
              backgroundColor: AppColor.accentColor,
              disabledBackgroundColor: const Color(0xFFB7E2C8),
              foregroundColor: AppColor.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: inCart
                ? null
                : () {
              final short = ProductShort(
                id: p.id,
                title: p.title,
                imageUrl: p.imageUrl,
                price: p.price,
              );
              final cart = context.read<CartBloc>();
              for (var i = 0; i < qty; i++) {
                cart.add(CartAdd(short));
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added ${p.title} ×$qty to cart')),
              );
            },
            child: Text(inCart ? 'Added to basket' : 'Add To Basket'),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        IconButton(
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
          padding: EdgeInsets.zero,
          iconSize: 18,
          color: const Color(0xFF7C7C7C),
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),

        Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFFE2E2E2)),
            color: Colors.white,
          ),
          child: Text(
            '$value',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),

        // плюс
        IconButton(
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
          padding: EdgeInsets.zero,
          iconSize: 18,
          color: AppColor.accentColor,
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

}
