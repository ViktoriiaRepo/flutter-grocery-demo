import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:first_app/models/favourites_product.dart';
import 'package:first_app/models/product_short.dart';
import 'package:first_app/utils/app_settings.dart';

class FavouritesState {
  final Map<String, FavouritesProduct> items;
  const FavouritesState({this.items = const {}});

  int get totalCount => items.length;
  bool isFav(String id) => items.containsKey(id.toString());
  List<FavouritesProduct> get list => items.values.toList();

  FavouritesState copyWith({Map<String, FavouritesProduct>? items}) =>
      FavouritesState(items: items ?? this.items);
}

class FavouritesCubit extends Cubit<FavouritesState> {
  FavouritesCubit(this._settings) : super(const FavouritesState());

  final AppSettings _settings;
  static const _storageKey = 'favourites_v1';

  Future<void> load() async {
    final s = _settings.prefs.getString(_storageKey);
    if (s == null || s.isEmpty) return;

    final raw = (jsonDecode(s) as List);
    final map = <String, FavouritesProduct>{};
    for (final e in raw) {
      final id = (e['id']).toString();
      map[id] = FavouritesProduct(
        product: ProductShort(
          id: id,
          title: (e['title'] ?? '') as String,
          imageUrl: (e['imageUrl'] ?? '') as String,
          price: (e['price'] as num).toDouble(),
        ),
        count: 1,
      );
    }
    emit(state.copyWith(items: map));
  }

  Future<void> _persist() async {
    final list = state.items.values.map((fp) => {
      'id': fp.product.id,
      'title': fp.product.title,
      'imageUrl': fp.product.imageUrl,
      'price': fp.product.price,
    }).toList();
    await _settings.prefs.setString(_storageKey, jsonEncode(list));
  }

  void toggle(ProductShort p) {
    final items = Map<String, FavouritesProduct>.from(state.items);
    final id = p.id.toString();
    if (items.containsKey(id)) {
      items.remove(id);
    } else {
      items[id] = FavouritesProduct(product: p, count: 1);
    }
    emit(state.copyWith(items: items));
    _persist();
  }

  void remove(String id) {
    final items = Map<String, FavouritesProduct>.from(state.items);
    items.remove(id);
    emit(state.copyWith(items: items));
    _persist();
  }

  void clear() {
    emit(const FavouritesState(items: {}));
    _persist();
  }
}
