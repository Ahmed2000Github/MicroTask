import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/theme_color_services.dart';

class NoDataFoundWidget extends StatelessWidget {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  String text;
  double? imageSize;
  double? textSize;
  Widget? action;
  Color? textColor;

  NoDataFoundWidget(
      {required this.text,
      this.imageSize,
      this.textSize,
      this.action,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Opacity(
        opacity: .8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/Error.png",
              width: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor ?? themeColor.fgColor,
                fontSize: textSize ?? 22,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            action ?? Container()
          ],
        ),
      ),
    );
  }
}
