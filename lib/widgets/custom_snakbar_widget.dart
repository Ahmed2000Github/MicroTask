import 'package:flutter/material.dart';

class CustomSnakbarWidget {
  BuildContext context;

  Color? color;
  double? height;
  CustomSnakbarWidget({required this.context, this.color, this.height});

  show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // duration: const Duration(seconds: 2),
        backgroundColor: color ?? Colors.blue,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - (height ?? 100),
            right: 20,
            left: 20),
        content: Container(
          alignment: Alignment.center,
          height: 22,
          child: Text(text,
              style: TextStyle(
                fontSize: text.length > 34 ? 15 : 18,
              )),
        )));
  }
}
