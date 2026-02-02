import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  Size get mediaQuerySize => MediaQuery.of(this).size;
  double get height => mediaQuerySize.height;
  double get width => mediaQuerySize.width;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
