import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomLoadingProgress extends StatelessWidget {
  Color color;
  double height;
  CustomLoadingProgress({Key? key, required this.color, required this.height})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Center(
        child: SpinKitSpinningLines(lineWidth: 5, color: color),
      ),
    );
  }
}
