import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/widgets/custom_appbar_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class AboutPage extends StatefulWidget {
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _first = GlobalKey();
  final GlobalKey _second = GlobalKey();
  final GlobalKey _third = GlobalKey();
  final GlobalKey _fourth = GlobalKey();
  final GlobalKey _fifth = GlobalKey();
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context)
          .startShowCase([_first, _second, _third, _fourth, _fifth]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: themeColor.bgColor,
        body: Column(
          children: [
            CustomAppBar(
              title: 'About',
            ),
            Showcase(
              key: _first,
              showcaseBackgroundColor: themeColor.drowerBgClor,
              textColor: themeColor.fgColor,
              title: "title",
              description: 'Press here to open ',
              child: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: themeColor.fgColor,
                ),
              ),
            ),
            Showcase(
              key: _second,
              showcaseBackgroundColor: themeColor.drowerBgClor,
              textColor: themeColor.fgColor,
              title: "title",
              description: 'Press here to open ',
              child: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: themeColor.fgColor,
                ),
              ),
            ),
          ],
        ));
  }
}
