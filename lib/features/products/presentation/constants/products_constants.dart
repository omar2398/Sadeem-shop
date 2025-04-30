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
  static const String reviewsTitle = 'Reviews';
  static const String warrantyInformationTitle = 'Warranty Information';
  static const String noWarrantyInformation =
      'No warranty information available';
  static const String returnPolicyTitle = 'Return Policy';
  static const String noReturnPolicy = 'No return policy information available';
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
  static const Color starColor = Color(0xFFFFD700);
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
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle detailsPriceStyle = TextStyle(
    fontSize: 26,
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

  static const TextStyle ratingTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle reviewsTitleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle reviewerNameStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle reviewCommentStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87.withOpacity(0.5),
  );

  static const TextStyle originalPriceStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle sectionContentStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
    height: 1.5,
  );
}
