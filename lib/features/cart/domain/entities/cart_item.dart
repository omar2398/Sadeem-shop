class CartItem {
  final int id;
  final String title;
  final double price;
  final int quantity;
  final double total;
  final double discountPercentage;
  final double discountedTotal;
  final String thumbnail;

  const CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.discountPercentage,
    required this.discountedTotal,
    required this.thumbnail,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      total: (json['total'] ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      discountedTotal: (json['discountedTotal'] ?? 0).toDouble(),
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }
}
