import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadeem_shop/features/cart/data/repositories/cart_repository.dart';
import 'package:sadeem_shop/features/cart/domain/entities/cart.dart';
import 'package:sadeem_shop/features/cart/domain/entities/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartCubit(this._repository) : super(CartInitial());
  Future<void> loadCart(int userId) async {
    print('CartCubit: Loading cart for user $userId');
    emit(CartLoading());
    try {
      final cart = await _repository.getUserCart(userId);
      print(
          'CartCubit: Cart loaded successfully: ${cart.products.length} items');
      emit(CartLoaded(cart));
    } catch (e) {
      print('CartCubit: Error loading cart: $e');
      emit(CartError(e.toString()));
    }
  }

  Future<void> addProduct(int userId, CartItem product) async {
    print('CartCubit: Adding product ${product.id} to cart');
    try {
      Cart? existingCart;
      List<CartItem> currentProducts = [];

      if (state is CartLoaded) {
        existingCart = (state as CartLoaded).cart;
        currentProducts = List<CartItem>.from(existingCart.products);
        print(
            'CartCubit: Using existing cart with ${currentProducts.length} items');
      }
      final existingProductIndex =
          currentProducts.indexWhere((p) => p.id == product.id);
      if (existingProductIndex != -1) {
        currentProducts[existingProductIndex] = CartItem(
          id: product.id,
          title: product.title,
          price: product.price,
          quantity:
              currentProducts[existingProductIndex].quantity + product.quantity,
          total: product.price *
              (currentProducts[existingProductIndex].quantity +
                  product.quantity),
          discountPercentage: product.discountPercentage,
          discountedTotal: product.price *
              (currentProducts[existingProductIndex].quantity +
                  product.quantity) *
              (1 - product.discountPercentage / 100),
          thumbnail: product.thumbnail,
        );
      } else {
        currentProducts.add(product);
      }
      print(
          'CartCubit: Creating new cart with ${currentProducts.length} items');
      emit(CartLoading());
      final newCart = await _repository.addToCart(userId, currentProducts);
      print(
          'CartCubit: New cart created successfully with ${newCart.products.length} items');
      emit(CartLoaded(newCart));
    } catch (e) {
      print('CartCubit: Error adding product: $e');
      emit(CartError(e.toString()));
    }
  }

  Future<void> removeProduct(CartItem product) async {
    try {
      emit(CartLoading());
      final currentState = state;
      if (currentState is CartLoaded) {
        final cart = currentState.cart;
        final updatedProducts =
            cart.products.where((p) => p.id != product.id).toList();
        final updatedCart = await _repository.updateCart(
          cart.id,
          updatedProducts,
          merge: false,
        );
        emit(CartLoaded(updatedCart));
      } else {
        throw Exception('No cart loaded');
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> updateProductQuantity(CartItem product, int newQuantity) async {
    try {
      emit(CartLoading());
      final currentState = state;
      if (currentState is CartLoaded) {
        final updatedCart = await _repository.updateCart(
          currentState.cart.id,
          [
            CartItem(
              id: product.id,
              title: product.title,
              price: product.price,
              quantity: newQuantity,
              total: product.total,
              discountPercentage: product.discountPercentage,
              discountedTotal: product.discountedTotal,
              thumbnail: product.thumbnail,
            )
          ],
          merge: true,
        );
        emit(CartLoaded(updatedCart));
      } else {
        throw Exception('No cart loaded');
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
