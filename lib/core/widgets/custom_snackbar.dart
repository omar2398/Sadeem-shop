import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    bool isSuccess = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
          ),
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.redAccent,
      ),
    );
  }
}