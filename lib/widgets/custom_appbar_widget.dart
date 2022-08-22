import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  String title;
  Widget? action;
  CustomAppBar({required this.title, this.action});
  @override
  Widget build(BuildContext context) {
    var icon = Icons.keyboard_arrow_left;
    if (AppLocalizations.of(context)?.localeName == 'ar') {
      icon = Icons.keyboard_arrow_right;
    }
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                      child: Icon(icon, color: themeColor.fgColor),
                    ),
                    Text(AppLocalizations.of(context)?.back ?? '',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: themeColor.fgColor)),
                  ],
                ),
              ),
            ),
            Spacer(),
            Text(title,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: themeColor.fgColor)),
            Spacer(),
            action ?? Container()
          ],
        ),
      ],
    );
  }
}
