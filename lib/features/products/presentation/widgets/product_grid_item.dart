import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sadeem_shop/features/products/presentation/pages/product_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/product.dart';
import '../constants/products_constants.dart';

class ProductGridItem extends StatefulWidget {
  final Product product;

  const ProductGridItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    final prefs = await SharedPreferences.getInstance();
    final likedProducts = prefs.getStringList('liked_products') ?? [];
    setState(() {
      isLiked = likedProducts.contains(widget.product.id.toString());
    });
  }

  Future<void> _toggleLike() async {
    final prefs = await SharedPreferences.getInstance();
    final likedProducts = prefs.getStringList('liked_products') ?? [];

    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likedProducts.add(widget.product.id.toString());
      } else {
        likedProducts.remove(widget.product.id.toString());
      }
    });

    await prefs.setStringList('liked_products', likedProducts);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: widget.product),
          ),
        );
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: ProductsColors.cardBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 90,
                    height: 120,
                    decoration: BoxDecoration(
                      color: ProductsColors.imagePlaceholderColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.product.thumbnail,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title,
                          style: ProductsStyles.titleStyle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.product.sku,
                          style: ProductsStyles.skuStyle,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${ProductsTexts.priceLabel}${widget.product.price}${ProductsTexts.currencySymbol}',
                              style: ProductsStyles.priceStyle,
                            ),
                            Text(
                              '${ProductsTexts.storageLabel}${widget.product.stock}',
                              style: ProductsStyles.storageStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 2,
              child: IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : HugeIcons.strokeRoundedFavourite,
                  color: isLiked ? Colors.red : Colors.grey,
                  size: 30,
                ),
                onPressed: _toggleLike,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
