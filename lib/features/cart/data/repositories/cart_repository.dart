import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';

class CartRepository {
  static const String baseUrl = 'https://dummyjson.com/carts';
  final Dio _dio;

  CartRepository({required Dio dio}) : _dio = dio..options.baseUrl = baseUrl;

  Future<Cart> getUserCart(int userId) async {
    try {
      debugPrint('Fetching cart for user: $userId');
      final response = await _dio.get('/user/$userId');
      debugPrint('Cart API Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['carts'] != null &&
            data['carts'] is List &&
            data['carts'].isNotEmpty) {
          debugPrint('Found cart data: ${data['carts'][0]}');
          return Cart.fromJson(data['carts'][0]);
        }
        debugPrint('No existing cart found, creating empty cart');
        return Cart(
          id: 0,
          products: [],
          total: 0,
          discountedTotal: 0,
          userId: userId,
          totalProducts: 0,
          totalQuantity: 0,
        );
      }
      throw Exception('Failed to load cart');
    } on DioException catch (e) {
      debugPrint('Cart API Error: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      throw Exception('Failed to load cart: ${e.message}');
    }
  }

  Future<Cart> addToCart(int userId, List<CartItem> products) async {
    try {
      final response = await _dio.post(
        '/add',
        data: {
          'userId': userId,
          'products': products
              .map((p) => {
                    'id': p.id,
                    'quantity': p.quantity,
                  })
              .toList(),
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        debugPrint('Add to cart response: ${response.data}');
        return Cart.fromJson(response.data);
      }
      throw Exception('Failed to add to cart. Status: ${response.statusCode}');
    } on DioException catch (e) {
      debugPrint('Add to cart error: ${e.message}');
      debugPrint('Request data: ${e.requestOptions.data}');
      debugPrint('Response: ${e.response?.data}');
      throw Exception('Failed to add to cart: ${e.message}');
    }
  }

  Future<Cart> updateCart(int cartId, List<CartItem> products,
      {bool merge = true}) async {
    try {
      if (cartId == 0) {
        debugPrint('Creating new cart instead of updating non-existent cart');
        return await addToCart(1, products);
      }
      final response = await _dio.put(
        '/$cartId',
        data: {
          'merge': merge,
          'products': products
              .map((p) => {
                    'id': p.id,
                    'quantity': p.quantity,
                  })
              .toList(),
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('Cart updated successfully');
        return Cart.fromJson(response.data);
      }
      throw Exception('Failed to update cart');
    } on DioException catch (e) {
      debugPrint('Update cart error: ${e.message}');
      debugPrint('Request data: ${e.requestOptions.data}');
      debugPrint('Response: ${e.response?.data}');
      throw Exception('Failed to update cart: ${e.message}');
    }
  }

  Future<bool> deleteCart(int cartId) async {
    try {
      final response = await _dio.delete('/$cartId');
      return response.statusCode == 200 && response.data['isDeleted'] == true;
    } on DioException catch (e) {
      throw Exception('Failed to delete cart: ${e.message}');
    }
  }
}
