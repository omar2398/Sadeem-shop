import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../constants/products_constants.dart';

class ProductRatingSection extends StatelessWidget {
  final Product product;

  const ProductRatingSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${product.rating}',
                style: ProductsStyles.ratingTextStyle,
              ),
              const SizedBox(width: 8),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < product.rating.floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: ProductsColors.starColor,
                    size: 20,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: product.reviews.length,
            itemBuilder: (context, index) {
              final review = product.reviews[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.reviewerName,
                          style: ProductsStyles.reviewerNameStyle,
                        ),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: ProductsColors.starColor,
                              size: 16,
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review.comment,
                      style: ProductsStyles.reviewCommentStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
