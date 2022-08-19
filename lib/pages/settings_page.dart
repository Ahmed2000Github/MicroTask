import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/synchronization/synch_bloc.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/widgets/custom_snakbar_widget.dart';
import 'package:showcaseview/showcaseview.dart';

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
  ];
  int timeIndex = 0;

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
              description: 'This page is for setting your app',
              child: Text(
                "Settings",
                style: TextStyle(
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
            _getCategory("Theme"),
            Showcase(
              key: _list[1],
              showcaseBackgroundColor: themeColor.drowerLightBgClor,
              textColor: themeColor.fgColor,
              description: 'Here you can switch the theme of app',
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
                  "Switch to " +
                      (!themeColor.isDarkMod ? "Dark" : "Light") +
                      " mode",
                  style: TextStyle(
                    fontSize: 18,
                    color: themeColor.fgColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getReminderCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          themeColor.isDarkMod = !themeColor.isDarkMod;
          widget.setParentState!();
        },
        child: Card(
          color: themeColor.drowerBgClor,
          child: Column(
            children: [
              _getCategory("Reminder"),
              StatefulBuilder(builder: (context, setInnetState) {
                return Showcase(
                  key: _list[2],
                  showcaseBackgroundColor: themeColor.drowerLightBgClor,
                  textColor: themeColor.fgColor,
                  description:
                      'Here tou can set the time between the start time of task and the run of reminder',
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
                        showModal(context, setInnetState);
                      },
                    ),
                    title: Text(
                      "Reminde me before ${timeList[timeIndex]} minutes ",
                      style: TextStyle(
                        fontSize: 18,
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
                  description:
                      'Here you can choose if the reminder run with sound or no',
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
                              ? "Desactivate"
                              : "Activate") +
                          " notification sound",
                      style: TextStyle(
                        fontSize: 18,
                        color: themeColor.fgColor,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCloudCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          themeColor.isDarkMod = !themeColor.isDarkMod;
          widget.setParentState!();
        },
        child: Card(
          color: themeColor.drowerBgClor,
          child: StatefulBuilder(builder: (context, setInnetState) {
            return Column(
              children: [
                _getCategory("Server Storage"),
                Showcase(
                  key: _list[4],
                  showcaseBackgroundColor: themeColor.drowerLightBgClor,
                  textColor: themeColor.fgColor,
                  description:
                      'This allow you to auto synchronize your data with the server\n desactivate it to do this manually',
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
                          setInnetState(() {});
                        }),
                    title: Text(
                      "" +
                          (configuration.isAutoSyncronize
                              ? "Desactivate"
                              : "Activate") +
                          " auto synchronization",
                      style: TextStyle(
                        fontSize: 18,
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
                      "Synchronize data with server",
                      style: TextStyle(
                        fontSize: 18,
                        color: themeColor.fgColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _getCategory(String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
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

  void showModal(BuildContext context, Function setInnerState) {
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              print(timeList[index]);
                              configuration.remindeTime = timeList[index];
                              CustomSnakbarWidget(
                                      context: context,
                                      height: 200,
                                      color: themeColor.primaryColor)
                                  .show(
                                      'From now all reminders will be start before ${timeList[index]} minutes.');
                              setInnerState(() {
                                timeIndex = index;
                              });
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text:
                                      '${(timeList[index] < 10 ? '0' : '') + timeList[index].toString()}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: themeColor.secondaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: '  Minutes',
                                  style: TextStyle(
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
}
