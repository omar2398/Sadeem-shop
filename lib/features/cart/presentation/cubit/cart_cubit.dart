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
      final currentState = state;
      if (currentState is CartLoaded) {
        final cart = currentState.cart;
        final updatedProducts =
            cart.products.where((p) => p.id != product.id).toList();
        final updatedCart = Cart(
          id: cart.id,
          products: updatedProducts,
          total: updatedProducts.fold(0.0, (sum, item) => sum + item.total),
          discountedTotal: updatedProducts.fold(
              0.0, (sum, item) => sum + item.discountedTotal),
          userId: cart.userId,
          totalProducts: updatedProducts.length,
          totalQuantity:
              updatedProducts.fold(0, (sum, item) => sum + item.quantity),
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
      final currentState = state;
      if (currentState is CartLoaded) {
        final cart = currentState.cart;
        final updatedProducts = List<CartItem>.from(cart.products);

        final productIndex =
            updatedProducts.indexWhere((p) => p.id == product.id);
        if (productIndex != -1) {
          if (newQuantity <= 0) {
            // If quantity is 0 or less, remove the product
            updatedProducts.removeAt(productIndex);
          } else {
            // Update the product with new quantity
            updatedProducts[productIndex] = CartItem(
              id: product.id,
              title: product.title,
              price: product.price,
              quantity: newQuantity,
              total: product.price * newQuantity,
              discountPercentage: product.discountPercentage,
              discountedTotal: product.price *
                  newQuantity *
                  (1 - product.discountPercentage / 100),
              thumbnail: product.thumbnail,
            );
          }

          // Create new cart with updated products
          final updatedCart = Cart(
            id: cart.id,
            products: updatedProducts,
            total: updatedProducts.fold(0.0, (sum, item) => sum + item.total),
            discountedTotal: updatedProducts.fold(
                0.0, (sum, item) => sum + item.discountedTotal),
            userId: cart.userId,
            totalProducts: updatedProducts.length,
            totalQuantity:
                updatedProducts.fold(0, (sum, item) => sum + item.quantity),
          );

          emit(CartLoaded(updatedCart));
        }
      } else {
        emit(CartLoaded(Cart(
          id: 1,
          products: [],
          total: 0,
          discountedTotal: 0,
          userId: 1,
          totalProducts: 0,
          totalQuantity: 0,
        )));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
