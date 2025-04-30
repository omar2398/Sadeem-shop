import 'package:flutter/material.dart';

class ProductsTexts {
  static const String searchHint = 'Search...';
  static const String noProductsFound = 'No products found';
  static const String retryButton = 'Retry';
  static const String loadError = 'Failed to load products';
  static const String priceLabel = 'Price: ';
  static const String storageLabel = 'In storage: ';
  static const String currencySymbol = '\$';
  static const String addToCartButton = 'Add to card';
}

class ProductsColors {
  static const filterButtonColor = Colors.blue;
  static const backgroundColor = Colors.white;
  static const searchBarFillColor = Color(0xFFF4F4F4);
  static const searchBarIconColor = Colors.white;
  static const Color titleColor = Colors.black;
  static const Color skuColor = Color(0xFF757575);
  static const Color priceColor = Colors.black;
  static const Color storageColor = Color(0xFF757575);
  static const Color cardBackgroundColor = Color(0xFFF4F8FB);
  static const Color imagePlaceholderColor = Color(0xFFEEEEEE);
  static const Color primaryButtonColor = Color(0xFF5775CD);
}

class ProductsStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle skuStyle = TextStyle(
    fontSize: 14,
    color: ProductsColors.skuColor,
  );

  static const TextStyle priceStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle storageStyle = TextStyle(
    fontSize: 14,
    color: ProductsColors.storageColor,
  );
  
  static const TextStyle detailsTitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle detailsPriceStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle detailsStorageStyle = TextStyle(
    fontSize: 16,
    color: ProductsColors.storageColor,
  );

  static const TextStyle detailsDescriptionStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
    height: 1.5,
  );
}
