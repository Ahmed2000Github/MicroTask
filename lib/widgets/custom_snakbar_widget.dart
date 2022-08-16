import 'package:flutter/material.dart';

class CustomSnakbarWidget {
  BuildContext context;

  Color? color;
  CustomSnakbarWidget({required this.context, this.color});

  show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color ?? Colors.blue,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            right: 20,
            left: 20),
        content: Text(text,
            style: const TextStyle(
              fontSize: 18,
            ))));
  }
}
