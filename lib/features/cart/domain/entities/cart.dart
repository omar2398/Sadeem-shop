import 'package:sadeem_shop/features/cart/domain/entities/cart_item.dart';

class Cart {
  final int id;
  final List<CartItem> products;
  final double total;
  final double discountedTotal;
  final int userId;
  final int totalProducts;
  final int totalQuantity;

  const Cart({
    required this.id,
    required this.products,
    required this.total,
    required this.discountedTotal,
    required this.userId,
    required this.totalProducts,
    required this.totalQuantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] ?? 0,
      products: (json['products'] as List<dynamic>?)
              ?.map((product) => CartItem.fromJson(product))
              .toList() ??
          [],
      total: (json['total'] ?? 0).toDouble(),
      discountedTotal: (json['discountedTotal'] ?? 0).toDouble(),
      userId: json['userId'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
      totalQuantity: json['totalQuantity'] ?? 0,
    );
  }

  Cart copyWith({
    int? id,
    List<CartItem>? products,
    double? total,
    double? discountedTotal,
    int? userId,
    int? totalProducts,
    int? totalQuantity,
  }) {
    return Cart(
      id: id ?? this.id,
      products: products ?? this.products,
      total: total ?? this.total,
      discountedTotal: discountedTotal ?? this.discountedTotal,
      userId: userId ?? this.userId,
      totalProducts: totalProducts ?? this.totalProducts,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }
}
