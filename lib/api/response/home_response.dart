// lib/api/response/home_response.dart
import 'package:first_app/api/http_response.dart';
import 'package:first_app/api/response/server_response.dart';
import 'package:first_app/utils/json_map.dart';

class HomeResponse extends ServerResponse {
  List<String> slider = [];
  List<HomeProduct> exclusive = [];
  List<HomeProduct> best = [];
  List<HomeCategory> categories = [];

  HomeResponse(HttpServerResponse res) : super(res);

  @override
  void parse(HttpServerResponse response) {
    super.parse(response);
    final root = JsonMap.toMap(response.data);

    // data може бути або List з одним елементом, або Map
    dynamic d = root['data'];
    Map<String, dynamic> block = {};
    if (d is List && d.isNotEmpty) {
      block = JsonMap.toMap(d.first);
    } else if (d is Map) {
      block = JsonMap.toMap(d);
    }

    slider = (block['slider'] as List? ?? const [])
        .map((e) => e.toString())
        .toList();

    exclusive = (block['exclusive'] as List? ?? const [])
        .map((e) => HomeProduct.fromJson(JsonMap.toMap(e)))
        .toList();

    best = (block['best'] as List? ?? const [])
        .map((e) => HomeProduct.fromJson(JsonMap.toMap(e)))
        .toList();

    categories = (block['category'] as List? ?? const [])
        .map((e) => HomeCategory.fromJson(JsonMap.toMap(e)))
        .toList();
  }
}

class HomeProduct {
  final String id;
  final String name;
  final String shortDescription;
  final String imageUrl;
  final double price;

  HomeProduct({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.imageUrl,
    required this.price,
  });

  factory HomeProduct.fromJson(Map<String, dynamic> j) => HomeProduct(
    id: (j['id'] ?? '').toString(),
    name: j['name']?.toString() ?? '',
    shortDescription: j['shortDescription']?.toString() ?? '',
    imageUrl: j['preview_image']?.toString() ?? '',
    price: double.tryParse(j['price']?.toString() ?? '') ?? 0.0,
  );
}

class HomeCategory {
  final String id;
  final String title;
  final String iconUrl;
  final String colorHex;

  HomeCategory({
    required this.id,
    required this.title,
    required this.iconUrl,
    required this.colorHex,
  });

  factory HomeCategory.fromJson(Map<String, dynamic> j) => HomeCategory(
    id: (j['id'] ?? '').toString(),
    title: j['name']?.toString() ?? '',
    iconUrl: j['icon']?.toString() ?? '',
    colorHex: j['color']?.toString() ?? '#FFFFFF',
  );
}
