import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomProgress extends StatelessWidget {
  Configuration get configuration => GetIt.I<Configuration>();
  double percent;
  double? radius;
  Color? textColor;
  double? lineWidth;
  double? textSize;
  ThemeColor themeColor;
  CustomProgress(
      {Key? key,
      required this.percent,
      required this.themeColor,
      this.radius,
      this.textColor,
      this.textSize,
      this.lineWidth})
      : super(key: key) {
    if (percent.isNaN) percent = 1;
  }
  @override
  Widget build(BuildContext context) {
    if (percent == 1) {
      return Column(
        children: [
          Icon(
            Icons.check_circle_outline_outlined,
            size: radius ?? 40,
            color: themeColor.secondaryColor,
          ),
          Text(
            AppLocalizations.of(context)?.completed ?? '',
            style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: textSize ?? 10.0),
          ),
        ],
      );
    } else {
      return CircularPercentIndicator(
        radius: radius ?? 40,
        lineWidth: lineWidth ?? 5.0,
        animation: true,
        percent: percent,
        center: Text(
          "${convertPercent(percent)}%",
          style: TextStyle(
              fontFamily: configuration.currentFont,
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: textSize ?? 10.0),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: themeColor.secondaryColor,
        backgroundColor: themeColor.errorColor,
        footer: Text(
          AppLocalizations.of(context)?.progress ?? '',
          style: TextStyle(
              fontFamily: configuration.currentFont,
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: textSize ?? 10.0),
        ),
      );
    }
  }

  String convertPercent(double percent) {
    String strPercent = percent.toString();
    if (percent == 1) {
      return "100";
    } else if (percent < 1 && strPercent.length >= 4) {
      return strPercent.substring(0, 4);
    }
    return strPercent;
  }
}
