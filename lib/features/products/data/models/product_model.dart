import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required int id,
    required String title,
    required String description,
    required String category,
    required double price,
    required double discountPercentage,
    required double rating,
    required int stock,
    required List<String> tags,
    required String brand,
    required String sku,
    required double weight,
    required Map<String, double> dimensions,
    required String warrantyInformation,
    required String shippingInformation,
    required String availabilityStatus,
    required List<ProductReview> reviews,
    required String returnPolicy,
    required int minimumOrderQuantity,
    required ProductMeta meta,
    required String thumbnail,
    required List<String> images,
  }) : super(
          id: id,
          title: title,
          description: description,
          category: category,
          price: price,
          discountPercentage: discountPercentage,
          rating: rating,
          stock: stock,
          tags: tags,
          brand: brand,
          sku: sku,
          weight: weight,
          dimensions: dimensions,
          warrantyInformation: warrantyInformation,
          shippingInformation: shippingInformation,
          availabilityStatus: availabilityStatus,
          reviews: reviews,
          returnPolicy: returnPolicy,
          minimumOrderQuantity: minimumOrderQuantity,
          meta: meta,
          thumbnail: thumbnail,
          images: images,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
      tags: List<String>.from(json['tags'] as List),
      brand: json['brand'] as String,
      sku: json['sku'] as String,
      weight: (json['weight'] as num).toDouble(),
      dimensions: {
        'width': (json['dimensions']['width'] as num).toDouble(),
        'height': (json['dimensions']['height'] as num).toDouble(),
        'depth': (json['dimensions']['depth'] as num).toDouble(),
      },
      warrantyInformation: json['warrantyInformation'] as String,
      shippingInformation: json['shippingInformation'] as String,
      availabilityStatus: json['availabilityStatus'] as String,
      reviews: (json['reviews'] as List)
          .map((review) =>
              ProductReviewModel.fromJson(review as Map<String, dynamic>))
          .toList(),
      returnPolicy: json['returnPolicy'] as String,
      minimumOrderQuantity: json['minimumOrderQuantity'] as int,
      meta: ProductMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
      thumbnail: json['thumbnail'] as String,
      images: List<String>.from(json['images'] as List),
    );
  }
}

class ProductReviewModel extends ProductReview {
  const ProductReviewModel({
    required double rating,
    required String comment,
    required DateTime date,
    required String reviewerName,
    required String reviewerEmail,
  }) : super(
          rating: rating,
          comment: comment,
          date: date,
          reviewerName: reviewerName,
          reviewerEmail: reviewerEmail,
        );

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
      reviewerName: json['reviewerName'] as String,
      reviewerEmail: json['reviewerEmail'] as String,
    );
  }
}

class ProductMetaModel extends ProductMeta {
  const ProductMetaModel({
    required DateTime createdAt,
    required DateTime updatedAt,
    required String barcode,
    required String qrCode,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
          barcode: barcode,
          qrCode: qrCode,
        );

  factory ProductMetaModel.fromJson(Map<String, dynamic> json) {
    return ProductMetaModel(
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      barcode: json['barcode'] as String,
      qrCode: json['qrCode'] as String,
    );
  }
}
