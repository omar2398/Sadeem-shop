import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sadeem_shop/features/cart/domain/entities/cart.dart';
import 'package:sadeem_shop/features/cart/domain/entities/cart_item.dart';
import '../cubit/cart_cubit.dart';
import '../constants/cart_constants.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Cart cart;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: CartColors.itemBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 120,
              decoration: BoxDecoration(
                color: CartColors.imagePlaceholderColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                item.thumbnail,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: CartStyles.itemTitleStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: CartStyles.itemPriceStyle,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          HugeIcons.strokeRoundedMinusSignSquare,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (item.quantity > 1) {
                            final newQuantity = item.quantity - 1;
                            context
                                .read<CartCubit>()
                                .updateProductQuantity(item, newQuantity);
                          }
                        },
                      ),
                      Text(
                        '${item.quantity}',
                        style: CartStyles.quantityTextStyle,
                      ),
                      IconButton(
                        icon: const Icon(HugeIcons.strokeRoundedPlusSignSquare),
                        onPressed: () {
                          final newQuantity = item.quantity + 1;
                          context
                              .read<CartCubit>()
                              .updateProductQuantity(item, newQuantity);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                HugeIcons.strokeRoundedDelete01,
                color: CartColors.deleteIconColor,
                size: 25,
              ),
              onPressed: () {
                context.read<CartCubit>().removeProduct(item);
              },
            ),
          ],
        ),
      ),
    );
  }
}
