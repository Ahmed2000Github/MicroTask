import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/theme_color_services.dart';

class CustomAppBar extends StatelessWidget {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  String title;
  CustomAppBar({required this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
                        child: Icon(Icons.keyboard_arrow_left,
                            color: themeColor.fgColor),
                      ),
                      Text('Back',
                          style: TextStyle(
                              fontSize: 22,
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
            ],
          ),
        ),
      ],
    );
  }
}
