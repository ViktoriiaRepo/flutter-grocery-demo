import 'package:first_app/api/http_response.dart';
import 'package:first_app/api/response/server_response.dart';
import 'package:first_app/utils/json_map.dart';
import 'package:first_app/models/catalog_models.dart';

class ProductResponse extends ServerResponse {
  ProductItem? product;

  ProductResponse(HttpServerResponse r) : super(r);

  @override
  parse(HttpServerResponse response) {
    super.parse(response);
    if (!isSuccess) return;

    final m = JsonMap.toMap(response.data)['data'] ?? {};
    final images = (m['images'] as List?)?.map((e) => e.toString()).toList() ?? const [];
    final preview = (m['preview_image'] ?? (images.isNotEmpty ? images.first : '')).toString();

    final nutritionsList = (m['nutritions'] as List?) ?? const [];
    final nutritions = <String, String>{};
    for (final n in nutritionsList) {
      final nm = n as Map?;
      final name = (nm?['name'] ?? '').toString();
      final value = (nm?['value'] ?? '').toString();
      if (name.isNotEmpty) nutritions[name] = value;
    }

    final priceStr = (m['price'] ?? '0').toString();
    final price = double.tryParse(priceStr) ?? 0;

    product = ProductItem(
      id: (m['id'] ?? '').toString(),
      title: (m['name'] ?? '').toString(),
      subtitle: (m['shortDescription'] ?? '').toString(),
      imageUrl: preview,
      price: price,
      category: '',
      section: null,
      description: (m['description'] ?? '').toString(),
      nutritions: nutritions,
      onAdd: () {},
    );
  }
}
