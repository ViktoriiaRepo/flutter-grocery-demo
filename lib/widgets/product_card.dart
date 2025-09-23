import 'package:flutter/material.dart';
import '../models/catalog_models.dart';

class ProductCard extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onAdd;
  final VoidCallback onOpen;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    required this.onOpen,
  });

  @override
    Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = BorderRadius.circular(20);

    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: r,
        border: const Border.fromBorderSide(BorderSide(color: Color(0xFFE2E2E2))),
        boxShadow: const [
          BoxShadow(blurRadius: 10, color: Color(0x11000000), offset: Offset(0, 4)),
        ],
      ),
      child: InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: Image.network(
              product.imageUrl,
              height: 70,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
              const SizedBox(height: 70, child: Icon(Icons.image_not_supported)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          product.title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
          Text(
            product.subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                ),
              ),
              const Spacer(),

              SizedBox(
                width: 45,
                height: 45,
                child: Material(
                  color: const Color(0xFF53B175),
                  borderRadius: BorderRadius.circular(17),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onAdd,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    ),
    );
  }
}
