import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/configuration.dart';

class CustomSnakbarWidget {
  BuildContext context;
  Configuration get configuration => GetIt.I<Configuration>();

  Color? color;
  double? height;
  Duration? duration;
  CustomSnakbarWidget(
      {required this.context, this.color, this.height, this.duration});

  show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: duration ?? const Duration(seconds: 3),
        backgroundColor: color ?? Colors.blue,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - (height ?? 100),
            right: 20,
            left: 20),
        content: Container(
          alignment: Alignment.center,
          height: 25,
          child: Text(text,
              style: TextStyle(
                fontFamily: configuration.currentFont,
                fontSize: text.length > 34 ? 15 : 18,
              )),
        )));
  }
}
