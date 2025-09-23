import 'package:first_app/api/http_api.dart';
import 'package:dio/dio.dart';
import 'package:first_app/api/response/home_response.dart';
import 'package:first_app/api/response/login_response.dart';
import 'package:first_app/api/response/product_response.dart';
import 'package:first_app/api/response/products_response.dart';
import 'package:first_app/api/response/register_response.dart';
import 'package:first_app/api/response/server_response.dart';
import 'package:first_app/models/api_order.dart';
import 'package:first_app/models/cart_product.dart';
import 'package:first_app/models/catalog_models.dart';
import 'package:flutter/foundation.dart';
import 'package:first_app/api/response/order_create_response.dart';


class ServerApi {
  HttpApi api = HttpApi(server: "https://it-flutter.wdscode.guru/wp-json/flutter/v1"
  );

  Future<LoginResponse> login({
    required String login,
    required String password,
  }){
    Map<String, dynamic> data = {
      "username": login,
      "password": password,
    };

    return api.sendPost(path: "/login", data: data)
    .then((value) => LoginResponse(value));
  }

  Future<RegisterResponse> register({
    required String username,
    required String email,
    required String password,
  }) {
    final data = {
      'password': password,
      'name': username,
      'username': email,
    };
    return api.sendPost(path: '/register', data: data)
        .then((v) => RegisterResponse(v));
  }


  Future<HomeResponse> loadHome() {
    return api.sendGet(path: "/home", data: {})
        .then((value) => HomeResponse(value));
  }

  Future<LoginResponse> uploadIcon({
    required String path,
}){
    Map<String, dynamic> data = {
      "file": MultipartFile.fromFileSync(path),
    };
    return api.sendFile(path:"/login", data: FormData.fromMap(data))
    .then((value) => LoginResponse(value));
  }
  Future<ProductsResponse> getProducts({
    String? categoryId,
    String? query,
  }) {
    final params = <String, dynamic>{};
    if (categoryId != null && categoryId.isNotEmpty) params['cat_id'] = categoryId;
    if (query != null && query.isNotEmpty) params['query'] = query;

    return api
        .sendGet(path: "/products", data: params)
        .then((v) => ProductsResponse(v));
  }

  Future<List<ApiCategory>> fetchCategories() async {
    final res = await api.sendGet(path: '/product/categories', data: {});
    final map = (res.data is Map ? res.data : {}) as Map;

    final list = (map['data'] as List?) ?? const [];
    return list.map((e) {
      final m = (e is Map ? e : {}) as Map;
      final rawName = (m['name'] ?? '').toString();
      final id      = (m['id'] ?? '').toString();
      final iconUrl = (m['icon'] ?? '').toString();


      return ApiCategory(
        id: id,
        title: rawName.replaceAll('&amp;', '&'),
        iconUrl: iconUrl,
        colorHex: m['color']?.toString(),
      );
    }).toList();
  }



  Future<ProductItem> fetchProductById(String id) async {
    final res = await api.sendGet(path: '/product', data: {'id': id});

    final map = (res.data is Map ? res.data : {}) as Map;
    final data = (map['data'] ?? {}) as Map;


    final nutriList = (data['nutritions'] as List?) ?? const [];
    final nutritions = <String, String>{
      for (final e in nutriList)
        if (e is Map) (e['name'] ?? '').toString(): (e['value'] ?? '').toString(),
    };

    return ProductItem(
      id: (data['id'] ?? '').toString(),
      title: (data['name'] ?? '').toString(),
      subtitle: (data['shortDescription'] ?? '').toString(),
      imageUrl: (data['preview_image'] ?? '').toString(),
      price: double.tryParse((data['price'] ?? '0').toString()) ?? 0.0,
      category: '',
      section: null,
      description: (data['description'] ?? '').toString(),
      nutritions: nutritions,
      onAdd: () => debugPrint('Add ${(data['name'] ?? '').toString()}'),
    );
  }


  Future<OrderCreateResponse> createOrder(List<CartProduct> items) async {
    final map = <String, dynamic>{};
    var i = 1;
    for (final it in items) {
      map['products[$i][id]'] = it.product.id.toString();
      map['products[$i][count]'] = it.count.toString();
      i++;
    }
    final res = await api.sendForm(
      path: '/order/create',
      data: map,
    );
    return OrderCreateResponse(res);
  }


  Future<List<ApiOrder>> fetchOrders() async {
    final res = await api.sendGet(path: '/orders', data: {});
    final payload = res.data;


    debugPrint('ORDERS payload: $payload');

    List list;

    if (payload is List) {
      list = payload;
    } else if (payload is Map) {
      final d = payload['data'];
      if (d is List) {
        list = d;
      } else if (d is Map && d['orders'] is List) {
        list = d['orders'];
      } else if (payload['orders'] is List) {
        list = payload['orders'];
      } else {
        list = const [];
      }
    } else {
      list = const [];
    }

    final orders = <ApiOrder>[];
    for (final e in list) {
      if (e is Map) {
        try {
          orders.add(ApiOrder.fromJson(e));
        } catch (err) {
          debugPrint('Order parse error: $err\n$e');
        }
      }
    }
    return orders;
  }

  Future<String?> uploadAvatar(String filePath) async {
    final file = await MultipartFile.fromFile(filePath);
    final form = FormData.fromMap({
      'avatar': file,
    });

    final res = await api.sendFile(path: '/user/avatar', data: form);
    final body = res.data;


    if (body is Map) {
      Map data;
      if (body['data'] is Map) {
        data = body['data'] as Map;
      } else {
        data = body;
      }

      String? url = (data['avatar'] ??
          data['avatarUrl'] ??
          data['url'] ??
          data['image'] ??
          data['path'])
          ?.toString();

      if ((url == null || url.isEmpty) && body['avatar'] != null) {
        url = body['avatar'].toString();
      }

      if (url != null && url.isNotEmpty) {
        return url;
      }
    }

    return null;
  }

}