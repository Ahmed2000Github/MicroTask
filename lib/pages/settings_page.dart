import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/theme_color_services.dart';

class SettingsPage extends StatefulWidget {
  VoidCallback? setParentState;

  SettingsPage({Key? key, this.setParentState}) : super(key: key);
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: themeColor.bgColor,
      child: Center(
          child: ListView(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
          child: ListTile(
            title: Text(
              "Settings",
              style: TextStyle(
                fontSize: 30,
                color: themeColor.fgColor,
              ),
            ),
          ),
        ),
        Container(
          height: height - 120,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    themeColor.isDarkMod = !themeColor.isDarkMod;
                    widget.setParentState!();
                  },
                  child: Card(
                    color: themeColor.drowerBgClor,
                    child: ListTile(
                      leading: Switch(
                          value: themeColor.isDarkMod,
                          onChanged: (value) {
                            themeColor.isDarkMod = value;
                            widget.setParentState!();
                          }),
                      title: Text(
                        "Switch to " +
                            (!themeColor.isDarkMod ? "Dark" : "Light") +
                            " mode",
                        style: TextStyle(
                          fontSize: 20,
                          color: themeColor.fgColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ])),
    );
  }
}
