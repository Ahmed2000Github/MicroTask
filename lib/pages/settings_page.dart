import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/lang/lang_cubit.dart';
import 'package:microtask/blocs/synchronization/synch_bloc.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/widgets/custom_snakbar_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  VoidCallback? setParentState;
  GlobalKey<ScaffoldState> scaffoldKey;

  SettingsPage({Key? key, required this.scaffoldKey, this.setParentState})
      : super(key: key);
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  Configuration get configuration => GetIt.I<Configuration>();
  List<int> timeList = [00, 05, 10, 15, 20, 25, 30];
  ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();
  final List<GlobalKey> _list = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  int timeIndex = 0;
  Alignment alignment = Alignment.centerLeft;

  @override
  void initState() {
    super.initState();

    timeIndex = timeList.indexOf(configuration.remindeTime);
    if (showCaseConfig.isLunched('settings')) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(Duration(seconds: 1))
            .then((value) => ShowCaseWidget.of(context).startShowCase(_list)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    alignment = Alignment.centerLeft;
    if (AppLocalizations.of(context)?.localeName == 'ar') {
      alignment = Alignment.centerRight;
    }
    return Container(
      color: themeColor.bgColor,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
          child: ListTile(
            title: Showcase(
              key: _list[0],
              showcaseBackgroundColor: themeColor.drowerLightBgClor,
              textColor: themeColor.fgColor,
              description: AppLocalizations.of(context)?.settingsd1 ?? '',
              child: Text(
                AppLocalizations.of(context)?.settings ?? '',
                style: TextStyle(
                  fontFamily: configuration.currentFont,
                  fontSize: 30,
                  color: themeColor.fgColor,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Hero(tag: 'hero', child: _getThemeCard()),
              _getReminderCard(),
              _getCloudCard(),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        )
      ]),
    );
  }

  Widget _getThemeCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: themeColor.drowerBgClor,
        child: Column(
          children: [
            _getCategory(AppLocalizations.of(context)?.theme ?? ''),
            Showcase(
              key: _list[1],
              showcaseBackgroundColor: themeColor.drowerLightBgClor,
              textColor: themeColor.fgColor,
              description: AppLocalizations.of(context)?.settingsd2 ?? '',
              child: GestureDetector(
                onTap: () {
                  themeColor.isDarkMod = !themeColor.isDarkMod;
                  widget.setParentState!();
                },
                child: ListTile(
                  leading: Icon(
                    themeColor.isDarkMod ? Icons.dark_mode : Icons.light_mode,
                    color: themeColor.isDarkMod
                        ? themeColor.primaryColor
                        : themeColor.fgColor,
                  ),
                  trailing: Switch(
                      value: themeColor.isDarkMod,
                      onChanged: (value) {
                        themeColor.isDarkMod = value;
                        widget.setParentState!();
                      }),
                  title: Text(
                    (AppLocalizations.of(context)?.switchTo ?? '') +
                        (!themeColor.isDarkMod
                            ? (AppLocalizations.of(context)?.darkMode ?? '')
                            : (AppLocalizations.of(context)?.lightMode ?? '')),
                    style: TextStyle(
                      fontFamily: configuration.currentFont,
                      fontSize: 17,
                      color: themeColor.fgColor,
                    ),
                  ),
                ),
              ),
            ),
            Showcase(
              key: _list[5],
              showcaseBackgroundColor: themeColor.drowerLightBgClor,
              textColor: themeColor.fgColor,
              description: AppLocalizations.of(context)?.settingsFontd ?? '',
              child: StatefulBuilder(builder: (context, setInnetState) {
                return ListTile(
                  leading: Icon(
                    Icons.font_download,
                    color: themeColor.fgColor,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit_note,
                      color: themeColor.primaryColor,
                    ),
                    onPressed: () {
                      showFontsModal(context, setInnetState);
                    },
                  ),
                  title: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: AppLocalizations.of(context)?.settingsFont ?? '',
                        style: TextStyle(
                          fontFamily: configuration.currentFont,
                          fontSize: 17,
                          color: themeColor.fgColor,
                        ),
                      ),
                      TextSpan(
                        text: configuration.fonts[configuration.currentFont] ==
                                'default'
                            ? AppLocalizations.of(context)?.defaultFont ?? ''
                            : configuration.fonts[configuration.currentFont],
                        style: TextStyle(
                          fontFamily: configuration.currentFont,
                          fontSize: 17,
                          color: themeColor.secondaryColor,
                        ),
                      ),
                    ]),
                  ),
                );
              }),
            ),
            Showcase(
              key: _list[6],
              showcaseBackgroundColor: themeColor.drowerLightBgClor,
              textColor: themeColor.fgColor,
              description: AppLocalizations.of(context)?.settingsLangd ?? '',
              child: StatefulBuilder(builder: (context, setInnetState) {
                return ListTile(
                  leading: Icon(
                    Icons.translate_rounded,
                    color: themeColor.fgColor,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit_note,
                      color: themeColor.primaryColor,
                    ),
                    onPressed: () {
                      showLangsModal(context, setInnetState);
                    },
                  ),
                  title: FittedBox(
                    alignment: alignment,
                    fit: BoxFit.scaleDown,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text:
                              AppLocalizations.of(context)?.settingsLang ?? '',
                          style: TextStyle(
                            fontFamily: configuration.currentFont,
                            fontSize: 17,
                            color: themeColor.fgColor,
                          ),
                        ),
                        TextSpan(
                          text: configuration.langs[configuration.currentLang],
                          style: TextStyle(
                            fontFamily: configuration.currentFont,
                            fontSize: 17,
                            color: themeColor.secondaryColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getReminderCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: themeColor.drowerBgClor,
        child: Column(
          children: [
            _getCategory(AppLocalizations.of(context)?.reminder ?? ''),
            StatefulBuilder(builder: (context, setInnetState) {
              return Showcase(
                key: _list[2],
                showcaseBackgroundColor: themeColor.drowerLightBgClor,
                textColor: themeColor.fgColor,
                description: AppLocalizations.of(context)?.settingsd3 ?? '',
                child: ListTile(
                  leading: Icon(
                    Icons.alarm,
                    color: themeColor.fgColor,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: themeColor.primaryColor,
                    ),
                    onPressed: () {
                      showTimeModal(context, setInnetState);
                    },
                  ),
                  title: Text(
                    AppLocalizations.of(context)
                            ?.remindeMe(timeList[timeIndex]) ??
                        '',
                    style: TextStyle(
                      fontFamily: configuration.currentFont,
                      fontSize: 17,
                      color: themeColor.fgColor,
                    ),
                  ),
                ),
              );
            }),
            StatefulBuilder(builder: (context, setInnerState) {
              return Showcase(
                key: _list[3],
                showcaseBackgroundColor: themeColor.drowerLightBgClor,
                textColor: themeColor.fgColor,
                description: AppLocalizations.of(context)?.settingsd4 ?? '',
                child: ListTile(
                  leading: Icon(
                    configuration.reminderSound
                        ? Icons.sensors
                        : Icons.sensors_off,
                    color: configuration.reminderSound
                        ? themeColor.primaryColor
                        : themeColor.fgColor,
                  ),
                  trailing: Switch(
                      value: configuration.reminderSound,
                      onChanged: (value) {
                        setInnerState(
                          () {
                            configuration.reminderSound = value;
                          },
                        );

                        context.read<CrudTaskBloc>().add(CrudTaskEvent(
                            requestEvent: CrudEventStatus.RESETREMINDER));
                      }),
                  title: Text(
                    "" +
                        (configuration.reminderSound
                            ? (AppLocalizations.of(context)?.desactivate ?? '')
                            : (AppLocalizations.of(context)?.activate ?? '')) +
                        (AppLocalizations.of(context)?.notificationSound ?? ''),
                    style: TextStyle(
                      fontFamily: configuration.currentFont,
                      fontSize: 17,
                      color: themeColor.fgColor,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _getCloudCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: themeColor.drowerBgClor,
        child: StatefulBuilder(builder: (context, setInnetState) {
          return Column(
            children: [
              _getCategory((AppLocalizations.of(context)?.serverStorage ?? '')),
              Showcase(
                key: _list[4],
                showcaseBackgroundColor: themeColor.drowerLightBgClor,
                textColor: themeColor.fgColor,
                description: (AppLocalizations.of(context)?.settingsd5 ?? ''),
                child: ListTile(
                  leading: Icon(
                    configuration.isAutoSyncronize
                        ? Icons.sync
                        : Icons.sync_disabled,
                    color: configuration.isAutoSyncronize
                        ? themeColor.primaryColor
                        : themeColor.fgColor,
                  ),
                  trailing: Switch(
                      value: configuration.isAutoSyncronize,
                      onChanged: (value) {
                        configuration.isAutoSyncronize = value;
                        if (value == true) {
                          context.read<SyncBloc>().add(SyncEvent.SYNC);
                        }
                        setInnetState(() {});
                      }),
                  title: Text(
                    "" +
                        (configuration.isAutoSyncronize
                            ? (AppLocalizations.of(context)?.desactivate ?? '')
                            : (AppLocalizations.of(context)?.activate ?? '')) +
                        (AppLocalizations.of(context)?.autoSynchronization ??
                            ''),
                    style: TextStyle(
                      fontFamily: configuration.currentFont,
                      fontSize: 17,
                      color: themeColor.fgColor,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !configuration.isAutoSyncronize,
                child: ListTile(
                  trailing: BlocBuilder<SyncBloc, StateStatus>(
                      builder: (context, state) {
                    switch (state) {
                      case StateStatus.LOADING:
                        return IconButton(
                          icon: Icon(
                            Icons.cloud_sync_outlined,
                            color: themeColor.primaryColor,
                          ),
                          onPressed: () {},
                        );
                      case StateStatus.ERROR:
                        return IconButton(
                          onPressed: () {
                            context.read<SyncBloc>().add(SyncEvent.SYNC);
                          },
                          icon: Icon(
                            Icons.cloud_off,
                            color: themeColor.errorColor,
                          ),
                        );
                      default:
                    }
                    return IconButton(
                      icon: Icon(
                        Icons.cloud_done_outlined,
                        color: themeColor.secondaryColor,
                      ),
                      onPressed: () {
                        context.read<SyncBloc>().add(SyncEvent.SYNC);
                      },
                    );
                  }),
                  title: Text(
                    AppLocalizations.of(context)?.synchronizeServer ?? '',
                    style: TextStyle(
                      fontFamily: configuration.currentFont,
                      fontSize: 17,
                      color: themeColor.fgColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _getCategory(String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: alignment,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: configuration.currentFont,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: themeColor.fgColor,
              ),
            ),
          ),
        ),
        Divider(
          indent: 3,
          color: themeColor.fgColor,
        ),
      ],
    );
  }

  void showTimeModal(BuildContext context, Function setInnerState) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              color: themeColor.drowerBgClor,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(children: [
                  for (var index = 0; index < timeList.length; index++)
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            print(timeList[index]);
                            configuration.remindeTime = timeList[index];
                            CustomSnakbarWidget(
                                    context: context,
                                    height: 200,
                                    color: themeColor.primaryColor)
                                .show(AppLocalizations.of(context)
                                        ?.settingsSN1(timeList[timeIndex]) ??
                                    '');
                            setInnerState(() {
                              timeIndex = index;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: alignment,
                            width: double.infinity,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text:
                                      '${(timeList[index] < 10 ? '0' : '') + timeList[index].toString()}',
                                  style: TextStyle(
                                    fontFamily: configuration.currentFont,
                                    fontSize: 24,
                                    color: themeColor.secondaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)?.minutes ??
                                      '',
                                  style: TextStyle(
                                    fontFamily: configuration.currentFont,
                                    fontSize: 24,
                                    color: themeColor.fgColor,
                                  ),
                                )
                              ])),
                            ),
                          ),
                        ),
                        index != timeList.length - 1
                            ? Divider(
                                color: themeColor.fgColor,
                              )
                            : Container()
                      ],
                    )
                ]),
              ),
            ),
          );
        });
  }

  void showLangsModal(BuildContext context, Function setInnerState) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              color: themeColor.drowerBgClor,
            ),
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: configuration.langs.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        TextButton(
                          onPressed: () async {
                            CustomSnakbarWidget(
                                    context: context,
                                    height: 200,
                                    color: themeColor.primaryColor)
                                .show(AppLocalizations.of(context)
                                        ?.settingsLangSN(configuration
                                            .langs.values
                                            .elementAt(index)) ??
                                    '');
                            var oldVal = configuration.currentLang;
                            await configuration.setCurrentLang(
                                configuration.langs.keys.elementAt(index));
                            context.read<LangCubit>().changeLang();
                            if ((window.locale.languageCode ==
                                    configuration.currentLang) ||
                                (oldVal == window.locale.languageCode)) {
                              setInnerState(
                                () {},
                              );
                            }
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: alignment,
                            width: double.infinity,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                configuration.langs.values.elementAt(index),
                                style: TextStyle(
                                  fontFamily: configuration.currentFont,
                                  fontSize: 24,
                                  color: themeColor.fgColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        index != timeList.length - 1
                            ? Divider(
                                color: themeColor.fgColor,
                              )
                            : Container()
                      ],
                    ),
                  )),
            ),
          );
        });
  }

  void showFontsModal(BuildContext context, Function setInnerState) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              color: themeColor.drowerBgClor,
            ),
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: configuration.fonts.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            configuration.currentFont =
                                configuration.fonts.keys.elementAt(index);
                            CustomSnakbarWidget(
                                    context: context,
                                    height: 200,
                                    color: themeColor.primaryColor)
                                .show(AppLocalizations.of(context)
                                        ?.settingsFontSN(configuration
                                            .fonts.values
                                            .elementAt(index)) ??
                                    '');
                            widget.setParentState!();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                configuration.fonts.values.elementAt(index),
                                style: TextStyle(
                                  fontFamily:
                                      configuration.fonts.keys.elementAt(index),
                                  fontSize: 24,
                                  color: themeColor.fgColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        index != timeList.length - 1
                            ? Divider(
                                color: themeColor.fgColor,
                              )
                            : Container()
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}
