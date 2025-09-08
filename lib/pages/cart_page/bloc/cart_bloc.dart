import 'package:bloc/bloc.dart';
import 'package:first_app/models/cart_product.dart';
import 'package:first_app/models/product_short.dart';


abstract class CartEvent {}

class CartAdd extends CartEvent {
  final ProductShort product;
  CartAdd(this.product);
}

class CartIncrement extends CartEvent {
  final String id;
  CartIncrement(this.id);
}

class CartDecrement extends CartEvent {
  final String id;
  CartDecrement(this.id);
}

class CartRemove extends CartEvent {
  final String id;
  CartRemove(this.id);
}

class CartClear extends CartEvent {}


class CartState {
  final Map<String, CartProduct> items;

  const CartState({required this.items});

  List<CartProduct> get products => items.values.toList(growable: false);

  int get totalCount =>
      items.values.fold<int>(0, (s, e) => s + e.count);

  double get totalPrice =>
      items.values.fold<double>(0.0, (s, e) => s + e.count * e.product.price);
}


class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState(items: {})) {
    on<CartAdd>(_onAdd);
    on<CartIncrement>(_onInc);
    on<CartDecrement>(_onDec);
    on<CartRemove>(_onRemove);
    on<CartClear>(_onClear);
  }

  void _onAdd(CartAdd e, Emitter<CartState> emit) {
    final m = Map<String, CartProduct>.from(state.items);
    final key = e.product.id.toString();
    if (m.containsKey(key)) {
      final old = m[key]!;
      m[key] = CartProduct(product: old.product, count: old.count + 1);
    } else {
      m[key] = CartProduct(product: e.product, count: 1);
    }
    emit(CartState(items: m));
  }

  void _onInc(CartIncrement e, Emitter<CartState> emit) {
    if (!state.items.containsKey(e.id)) return;
    final m = Map<String, CartProduct>.from(state.items);
    final old = m[e.id]!;
    m[e.id] = CartProduct(product: old.product, count: old.count + 1);
    emit(CartState(items: m));
  }

  void _onDec(CartDecrement e, Emitter<CartState> emit) {
    if (!state.items.containsKey(e.id)) return;
    final m = Map<String, CartProduct>.from(state.items);
    final old = m[e.id]!;
    final next = old.count - 1;
    if (next <= 0) {
      m.remove(e.id);
    } else {
      m[e.id] = CartProduct(product: old.product, count: next);
    }
    emit(CartState(items: m));
  }

  void _onRemove(CartRemove e, Emitter<CartState> emit) {
    final m = Map<String, CartProduct>.from(state.items);
    m.remove(e.id);
    emit(CartState(items: m));
  }

  void _onClear(CartClear e, Emitter<CartState> emit) {
    emit(const CartState(items: {}));
  }
}
