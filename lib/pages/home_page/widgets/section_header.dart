import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 25, right: 25, bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF53B175)),
            child: const Text('See all'),
          ),
        ],
      ),
    );
  }
}
