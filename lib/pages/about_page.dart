import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/widgets/custom_appbar_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatefulWidget {
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();
  final colorizeColors = [
    Colors.blue,
    Colors.purple,
    Colors.yellow,
    Colors.red,
    Colors.green,
  ];
  TextStyle? colorizeTextStyle;
  @override
  void initState() {
    super.initState();
    colorizeTextStyle = TextStyle(
      color: themeColor.primaryColor,
      fontSize: 34.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: themeColor.bgColor,
        body: Column(
          children: [
            CustomAppBar(
              title: AppLocalizations.of(context)?.about ?? '',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    // Text(
                    //   AppLocalizations.of(context)?.helloWorld ?? '',
                    //   style: TextStyle(height: 1.5, color: themeColor.fgColor),
                    // ),
                    SizedBox(
                      height: height * .1,
                      child: Center(
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            ColorizeAnimatedText(
                              AppLocalizations.of(context)
                                      ?.welcometoMicroTask ??
                                  '',
                              textStyle: colorizeTextStyle!,
                              speed: const Duration(milliseconds: 800),
                              colors: colorizeColors,
                            ),
                          ],
                          isRepeatingAnimation: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 40),
                          children: <TextSpan>[
                            TextSpan(
                              text: AppLocalizations.of(context)?.aboutp1 ?? '',
                              style: TextStyle(
                                  height: 1.5, color: themeColor.fgColor),
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)?.aboutp2 ?? '',
                              style: TextStyle(
                                  height: 1.5, color: themeColor.fgColor),
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)?.aboutp3 ?? '',
                              style: TextStyle(
                                  height: 1.5, color: themeColor.fgColor),
                            ),
                          ],
                        ),
                        textScaleFactor: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
