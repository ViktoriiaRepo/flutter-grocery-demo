class ApiOrderItem {
  final String id;
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;

  ApiOrderItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  factory ApiOrderItem.fromJson(Map m) => ApiOrderItem(
    id: (m['id'] ?? '').toString(),
    name: (m['name'] ?? m['title'] ?? '').toString(),
    imageUrl: (m['preview_image'] ?? m['image'] ?? m['imageUrl'] ?? '').toString(),
    quantity: int.tryParse((m['quantity'] ?? m['count'] ?? '1').toString()) ?? 1,
    price: double.tryParse((m['price'] ?? '0').toString()) ?? 0.0,
  );
}

class ApiOrder {
  final String id;
  final double total;
  final String? status;
  final DateTime? createdAt;
  final List<ApiOrderItem> items;

  ApiOrder({
    required this.id,
    required this.total,
    required this.items,
    this.status,
    this.createdAt,
  });

  int get itemsCount => items.fold(0, (s, e) => s + e.quantity);

  factory ApiOrder.fromJson(Map m) {
    final rawItems = (m['products'] ?? m['items'] ?? const []) as List? ?? const [];
    return ApiOrder(
      id: (m['id'] ?? '').toString(),
      total: double.tryParse((m['total'] ?? m['sub_total'] ?? '0').toString()) ?? 0.0,
      status: (m['status'] ?? m['state'] ?? '').toString(),
      createdAt: (() {
        final s = (m['created_at'] ?? m['date'] ?? '').toString();
        return s.isEmpty ? null : DateTime.tryParse(s);
      })(),
      items: [for (final e in rawItems) if (e is Map) ApiOrderItem.fromJson(e)],
    );
  }
}
