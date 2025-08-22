import 'package:first_app/api/http_response.dart';
import 'package:first_app/api/response/server_response.dart';
import 'package:first_app/models/catalog_models.dart';
import 'package:flutter/foundation.dart';

class ProductsResponse extends ServerResponse {
  List<ProductItem> items = [];

  ProductsResponse(HttpServerResponse response) : super(response);

  @override
  void parse(HttpServerResponse response) {
    super.parse(response);
    if (!isSuccess) return;

    final root = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    final data = (root['data'] ?? {}) as Map<String, dynamic>;
    final list = (data['products'] ?? []) as List;

    items = list.map<ProductItem>((raw) {
      final m = raw as Map<String, dynamic>;
      final id = (m['id'] ?? '').toString();
      final name = (m['name'] ?? '') as String;
      final subtitle = (m['shortDescription'] ?? '') as String;
      final image = (m['preview_image'] ?? '') as String;
      final price = double.tryParse('${m['price']}') ?? 0.0;

      return ProductItem(
        id: id,
        title: name,
        subtitle: subtitle,
        imageUrl: image,
        price: price,
        category: '',
        section: null,
        description: null,
        nutritions: const {},
        onAdd: () => debugPrint('Add $name'),
      );
    }).toList(growable: false);
  }
}
