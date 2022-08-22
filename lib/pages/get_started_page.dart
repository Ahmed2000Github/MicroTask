import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GetStartedPage extends StatelessWidget {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var alignment = Alignment.centerLeft;
    if ((AppLocalizations.of(context)?.localeName ?? '') == 'ar') {
      alignment = Alignment.centerRight;
    }
    return Scaffold(
      backgroundColor: themeColor.bgColor,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: alignment,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                AppLocalizations.of(context)?.welcomeTo ?? '',
                style: TextStyle(
                  color: themeColor.fgColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
          ),
          Container(
            child: Container(
              height: height * .2,
              child: Center(
                child: Image.asset(
                  "assets/images/microtask_" +
                      (themeColor.isDarkMod ? "dark" : "light") +
                      ".png",
                  width: width * .5,
                ),
              ),
            ),
          ),
          Lottie.asset('assets/lotties/flying_rocket_sky.json',
              width: width * .8),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 70,
            width: width * .8,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, route.mainPage);
              },
              child: Card(
                elevation: 4,
                color: themeColor.primaryColor,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.getStarted ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
