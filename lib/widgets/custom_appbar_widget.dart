import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  Configuration get configuration => GetIt.I<Configuration>();
  String title;
  Widget? action;
  Color? textColor;
  CustomAppBar({required this.title, this.action, this.textColor});
  @override
  Widget build(BuildContext context) {
    var icon = Icons.keyboard_arrow_left;
    if (AppLocalizations.of(context)?.localeName == 'ar') {
      icon = Icons.keyboard_arrow_right;
    }
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                      child: Icon(icon, color: textColor ?? themeColor.fgColor),
                    ),
                    Text(AppLocalizations.of(context)?.back ?? '',
                        style: TextStyle(
                            fontFamily: configuration.currentFont,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: textColor ?? themeColor.fgColor)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Text(title,
                style: TextStyle(
                    fontFamily: configuration.currentFont,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? themeColor.fgColor)),
            const Spacer(),
            action ?? Container()
          ],
        ),
      ],
    );
  }
}
