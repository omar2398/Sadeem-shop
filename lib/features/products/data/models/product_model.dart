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
    try {
      return ProductModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        category: json['category'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        discountPercentage:
            (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        stock: json['stock'] as int? ?? 0,
        tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? [],
        brand: json['brand'] as String? ?? '',
        sku: json['sku'] as String? ?? '',
        weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
        dimensions: json['dimensions'] != null
            ? {
                'width':
                    (json['dimensions']['width'] as num?)?.toDouble() ?? 0.0,
                'height':
                    (json['dimensions']['height'] as num?)?.toDouble() ?? 0.0,
                'depth':
                    (json['dimensions']['depth'] as num?)?.toDouble() ?? 0.0,
              }
            : {'width': 0.0, 'height': 0.0, 'depth': 0.0},
        warrantyInformation: json['warrantyInformation'] as String? ?? '',
        shippingInformation: json['shippingInformation'] as String? ?? '',
        availabilityStatus: json['availabilityStatus'] as String? ?? 'In Stock',
        reviews: (json['reviews'] as List?)?.map((review) {
              final reviewMap = review as Map<String, dynamic>;
              return ProductReviewModel(
                rating: (reviewMap['rating'] as num?)?.toDouble() ?? 0.0,
                comment: reviewMap['comment'] as String? ?? '',
                date: DateTime.tryParse(reviewMap['date'] as String? ?? '') ??
                    DateTime.now(),
                reviewerName: reviewMap['reviewerName'] as String? ?? '',
                reviewerEmail: reviewMap['reviewerEmail'] as String? ?? '',
              );
            }).toList() ??
            [],
        returnPolicy: json['returnPolicy'] as String? ?? '',
        minimumOrderQuantity: json['minimumOrderQuantity'] as int? ?? 1,
        meta: ProductMetaModel(
          createdAt:
              DateTime.tryParse(json['meta']?['createdAt'] as String? ?? '') ??
                  DateTime.now(),
          updatedAt:
              DateTime.tryParse(json['meta']?['updatedAt'] as String? ?? '') ??
                  DateTime.now(),
          barcode: json['meta']?['barcode'] as String? ?? '',
          qrCode: json['meta']?['qrCode'] as String? ?? '',
        ),
        thumbnail:
            json['thumbnail'] as String? ?? 'https://placehold.co/600x400',
        images: (json['images'] as List?)
                ?.map((image) =>
                    image as String? ?? 'https://placehold.co/600x400')
                .toList() ??
            [],
      );
    } catch (e) {
      print('Error parsing product JSON: $e');
      rethrow;
    }
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
}
