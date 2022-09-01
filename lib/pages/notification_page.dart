import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart' as intl;
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/task/task_bloc.dart';
import 'package:microtask/blocs/task/task_event.dart';
import 'package:microtask/blocs/task/task_state.dart';
import 'package:microtask/blocs/today/today_bloc.dart';
import 'package:microtask/blocs/today/today_event.dart';
import 'package:microtask/blocs/today/today_state.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/models/task_model.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPage extends StatefulWidget {
  User? user;
  String taskId;

  var categoryId;
  NotificationPage({required this.taskId}) {
    print(taskId);
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  Configuration get configuration => GetIt.I<Configuration>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();
  final List<GlobalKey> _list = [
    GlobalKey(),
    GlobalKey(),
  ];
  Animation<double>? animation;

  AnimationController? controller;
  Task? task;
  @override
  initState() {
    super.initState();
    context.read<TodayBloc>().add(TodayEvent(
          requestEvent: CrudEventStatus.FETCH,
        ));
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this //
            );

    controller?.repeat(reverse: true);
    if (showCaseConfig.isLunched(route.notificationPage)) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(Duration(seconds: 1))
            .then((value) => ShowCaseWidget.of(context).startShowCase(_list)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    animation =
        new Tween(begin: height * .21, end: height * .225).animate(controller!);
    var alignment = Alignment.centerLeft;
    if ((AppLocalizations.of(context)?.localeName ?? '') == 'ar') {
      alignment = Alignment.centerRight;
    }

    return WillPopScope(
      onWillPop: () {
        handleData(TaskStatus.UNDONE);
        return Future<bool>.value(true);
      },
      child: Scaffold(
        backgroundColor: themeColor.bgColor,
        body: BlocListener<TodayBloc, TodayState>(
          listener: (context, state) {
            if (state.requestState == StateStatus.LOADED) {
              task = state.todayTasks?.firstWhere(
                  (element) => element.id == widget.taskId,
                  orElse: () => Task());
              setState(() {});
            }
          },
          child: task == null
              ? Container()
              : Stack(
                  children: [
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * .1, (height * .2), width * .1, 50),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: height * .7,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            themeColor.drowerBgClor,
                            themeColor.drowerBgClor
                          ]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 110, 8, 8),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.title,
                                  color: themeColor.fgColor,
                                  size: 30,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)?.title ?? '',
                                  style: TextStyle(
                                      fontFamily: configuration.currentFont,
                                      fontSize: 23,
                                      color: themeColor.fgColor),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Container(
                                  alignment: alignment,
                                  child: Text(
                                    task?.title ?? '',
                                    style: TextStyle(
                                        fontFamily: configuration.currentFont,
                                        fontSize: 18,
                                        color: themeColor.fgColor),
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.description,
                                  color: themeColor.fgColor,
                                  size: 30,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)?.description ??
                                      '',
                                  style: TextStyle(
                                      fontFamily: configuration.currentFont,
                                      fontSize: 23,
                                      color: themeColor.fgColor),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Container(
                                  constraints: const BoxConstraints(
                                      minHeight: 20, maxHeight: 100),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      alignment: alignment,
                                      child: Text(
                                        task?.description ?? '',
                                        style: TextStyle(
                                            fontFamily:
                                                configuration.currentFont,
                                            fontSize: 15,
                                            color: themeColor.fgColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.today,
                                  color: themeColor.fgColor,
                                  size: 30,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)?.taskStart ?? '',
                                  style: TextStyle(
                                      fontFamily: configuration.currentFont,
                                      fontSize: 23,
                                      color: themeColor.fgColor),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Container(
                                  alignment: alignment,
                                  child: Text(
                                    (AppLocalizations.of(context)?.todayAt(
                                            intl.DateFormat("HH:mm:ss").format(
                                                task?.startDateTime ??
                                                    DateTime.now())) ??
                                        ''),
                                    style: TextStyle(
                                        fontFamily: configuration.currentFont,
                                        fontSize: 18,
                                        color: themeColor.primaryColor),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Showcase(
                                      key: _list[0],
                                      showcaseBackgroundColor:
                                          themeColor.drowerLightBgClor,
                                      textColor: themeColor.fgColor,
                                      description: AppLocalizations.of(context)
                                              ?.notifisd1 ??
                                          '',
                                      child: FloatingActionButton(
                                        tooltip: AppLocalizations.of(context)
                                                ?.undoneButton ??
                                            '',
                                        backgroundColor: themeColor.errorColor,
                                        onPressed: () {
                                          handleData(TaskStatus.UNDONE);
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Showcase(
                                      key: _list[1],
                                      showcaseBackgroundColor:
                                          themeColor.drowerLightBgClor,
                                      textColor: themeColor.fgColor,
                                      description: AppLocalizations.of(context)
                                              ?.notifisd2 ??
                                          '',
                                      child: FloatingActionButton(
                                        heroTag: 'h1',
                                        tooltip: AppLocalizations.of(context)
                                                ?.doneButton ??
                                            '',
                                        backgroundColor:
                                            themeColor.secondaryColor,
                                        onPressed: () {
                                          handleData(TaskStatus.DOING);
                                        },
                                        child: const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                        animation: animation!,
                        builder: (BuildContext ctx, Widget? child) {
                          return Positioned(
                            top: animation?.value,
                            child: Container(
                              height: 100,
                              width: width,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      themeColor.primaryLightColor,
                                      themeColor.primaryColor
                                    ]),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  height: 100,
                                  width: width * .9,
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: width * .25,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/new_task.png"),
                                            fit: BoxFit.fill,
                                            repeat: ImageRepeat.noRepeat,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)
                                                      ?.welcome(widget.user
                                                              ?.displayName ??
                                                          '') ??
                                                  '',
                                              style: TextStyle(
                                                  fontFamily:
                                                      configuration.currentFont,
                                                  height: 2,
                                                  fontSize: 23,
                                                  color: Colors.white),
                                            ),
                                            FittedBox(
                                              child: Text(
                                                AppLocalizations.of(context)
                                                        ?.haveNewTask ??
                                                    '',
                                                style: TextStyle(
                                                    fontFamily: configuration
                                                        .currentFont,
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
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

  handleData(TaskStatus status) {
    if (task?.repeatType == RepeatType.None) {
      task?.status = status;
      context
          .read<CrudTaskBloc>()
          .add(CrudTaskEvent(requestEvent: CrudEventStatus.EDIT, task: task));
      context
          .read<CategoryBloc>()
          .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));
      context
          .read<TodayBloc>()
          .add(TodayEvent(requestEvent: CrudEventStatus.FETCH));
      context
          .read<CategoryBloc>()
          .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));
      context.read<TaskBloc>().add(TaskEvent(
          requestEvent: CrudEventStatus.FETCH,
          date: DateTime.now(),
          categoryId: task?.categoryId ?? ''));
      context
          .read<CrudTaskBloc>()
          .add(CrudTaskEvent(requestEvent: CrudEventStatus.RESET));
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
