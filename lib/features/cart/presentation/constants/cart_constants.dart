import 'package:flutter/material.dart';

class CartColors {
  static const Color itemBackgroundColor = Color(0xFFF4F8FB);
  static const Color imagePlaceholderColor = Color(0xFFEEEEEE);
  static const Color primaryColor = Color(0xFF5775CD);
  static const Color deleteIconColor = Colors.red;
  static const Color backgroundColor = Colors.white;
}

class CartStyles {
  static const TextStyle itemTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle itemPriceStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: CartColors.primaryColor,
  );

  static const TextStyle quantityTextStyle = TextStyle(fontSize: 16);

  static const TextStyle totalLabelStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  static const TextStyle totalAmountStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: CartColors.primaryColor,
  );

  static const TextStyle appBarTitleStyle = TextStyle(color: Colors.black);
}

class CartTexts {
  static const String appBarTitle = 'Your Cart';
  static const String emptyCartTitle = 'Your cart is empty';
  static const String retryButtonText = 'Retry';
  static const String checkoutButtonText = 'Checkout';
  static const String totalLabel = 'Total';
}
