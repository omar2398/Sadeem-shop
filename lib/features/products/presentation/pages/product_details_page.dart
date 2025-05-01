import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadeem_shop/core/widgets/custom_snackbar.dart';
import 'package:sadeem_shop/features/cart/domain/entities/cart_item.dart';
import 'package:sadeem_shop/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:sadeem_shop/features/cart/presentation/cubit/cart_state.dart';
import 'package:sadeem_shop/features/products/domain/entities/product.dart';
import '../constants/products_constants.dart';
import '../widgets/product_rating_section.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProductsColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: ProductsColors.backgroundColor,
        elevation: 0,
        title: Text(
          widget.product.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.product.images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final imageUrl = widget.product.images[index];
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: ProductsColors.imagePlaceholderColor,
                        ),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.error_outline,
                                size: 32,
                                color: Colors.grey,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        widget.product.images.asMap().entries.map((entry) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == entry.key
                              ? ProductsColors.primaryButtonColor
                              : Colors.grey.withOpacity(0.5),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: ProductsStyles.detailsTitleStyle,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: ProductsColors.cardBackgroundColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${ProductsTexts.currencySymbol}${widget.product.price}',
                            style: ProductsStyles.detailsPriceStyle,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ProductsColors.cardBackgroundColor),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                '${ProductsTexts.storageLabel}${widget.product.stock}',
                                style: ProductsStyles.detailsStorageStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: ProductsColors.storageColor.withOpacity(0.05),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        widget.product.description,
                        style: ProductsStyles.detailsDescriptionStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined,
                        color: Colors.green),
                    title: Text(
                      ProductsTexts.warrantyInformationTitle,
                      style: ProductsStyles.sectionTitleStyle,
                    ),
                    subtitle: Text(
                      widget.product.warrantyInformation ??
                          ProductsTexts.noWarrantyInformation,
                      style: ProductsStyles.sectionContentStyle,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.assignment_return_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      ProductsTexts.returnPolicyTitle,
                      style: ProductsStyles.sectionTitleStyle,
                    ),
                    subtitle: Text(
                      widget.product.returnPolicy ??
                          ProductsTexts.noReturnPolicy,
                      style: ProductsStyles.sectionContentStyle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ProductRatingSection(product: widget.product),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(22),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state is CartLoading
                  ? null
                  : () async {
                      final cartItem = CartItem(
                        id: widget.product.id,
                        title: widget.product.title,
                        price: widget.product.price,
                        quantity: 1,
                        total: widget.product.price,
                        discountPercentage:
                            widget.product.discountPercentage ?? 0,
                        discountedTotal: widget.product.price *
                            (1 -
                                (widget.product.discountPercentage ?? 0) / 100),
                        thumbnail: widget.product.thumbnail,
                      );
                      await context.read<CartCubit>().addProduct(1, cartItem);
                      final currentState = context.read<CartCubit>().state;
                      if (currentState is CartLoaded) {
                        CustomSnackBar.show(
                          message: 'Added to cart successfully',
                          isSuccess: true,
                          context: context,
                        );
                      }
                      if (currentState is CartError) {
                        CustomSnackBar.show(
                          message: 'Error in adding your product',
                          isSuccess: false,
                          context: context,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: ProductsColors.primaryButtonColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: state is CartLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: ProductsColors.backgroundColor,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      ProductsTexts.addToCartButton,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ProductsColors.backgroundColor,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
