
class ProductShort {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;

  const ProductShort({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.subtitle = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'imageUrl': imageUrl,
    'price': price,
  };

  factory ProductShort.fromJson(Map<String, dynamic> json) => ProductShort(
    id: json['id'] as String,
    title: json['title'] as String,
    subtitle: (json['subtitle'] as String?) ?? '',
    imageUrl: json['imageUrl'] as String,
    price: (json['price'] as num).toDouble(),
  );
}
