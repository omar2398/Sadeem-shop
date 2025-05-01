import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sadeem_shop/features/cart/domain/entities/cart.dart';
import 'package:sadeem_shop/features/cart/domain/entities/cart_item.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_item_widget.dart';
import '../constants/cart_constants.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart(11);
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(HugeIcons.strokeRoundedShoppingCartCheckOut02,
              size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            CartTexts.emptyCartTitle,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5775CD),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            onPressed: () async {
              await context.read<CartCubit>().loadCart(1);
            },
            child: Text(
              CartTexts.retryButtonText,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CartColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CartColors.backgroundColor,
        elevation: 0,
        title: Text(
          CartTexts.appBarTitle,
          style: CartStyles.appBarTitleStyle,
        ),
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            print('CartPage: Error state received: ${state.message}');
            CustomSnackBar.show(
                context: context, message: state.message, isSuccess: false);
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoaded && state.cart.products.isEmpty) {
            return _buildEmptyCart();
          }

          if (state is CartLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.cart.products.length,
                    itemBuilder: (context, index) => CartItemWidget(
                      item: state.cart.products[index],
                      cart: state.cart,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '\$${state.cart.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5775CD),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          CustomSnackBar.show(
                              context: context,
                              message: 'Checkout not implemented yet',
                              isSuccess: false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5775CD),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return _buildEmptyCart();
        },
      ),
    );
  }
}
