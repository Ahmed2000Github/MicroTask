import 'dart:ui';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/category/category_state.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/crud_task/crud_task_state.dart';
import 'package:microtask/blocs/home/home_bloc.dart';
import 'package:microtask/blocs/lang/lang_cubit.dart';
import 'package:microtask/blocs/synchronization/synch_bloc.dart';
import 'package:microtask/blocs/today/today_bloc.dart';
import 'package:microtask/blocs/today/today_event.dart';
import 'package:microtask/blocs/today/today_state.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/services/enum_translate_services.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/custum_progress.dart';
import 'package:microtask/widgets/no_data_found_widget.dart';
import 'package:microtask/widgets/profile_image_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  User? user;
  GlobalKey<ScaffoldState> scaffoldKey;

  HomePage({required this.scaffoldKey}) {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  Configuration get configuration => GetIt.I<Configuration>();
  ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();
  final GlobalKey _first = GlobalKey();
  final GlobalKey _second = GlobalKey();
  final GlobalKey _thirth = GlobalKey();

  DateTime today = DateTime.now();
  @override
  void initState() {
    super.initState();
    context
        .read<CategoryBloc>()
        .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));

    context
        .read<TodayBloc>()
        .add(TodayEvent(requestEvent: CrudEventStatus.FETCH));
    if (showCaseConfig.isLunched('home')) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(const Duration(seconds: 1)).then((value) =>
            ShowCaseWidget.of(context)
                .startShowCase([_first, _second, _thirth])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Alignment alignment = Alignment.centerLeft;
    if (AppLocalizations.of(context)?.localeName == 'ar') {
      alignment = Alignment.centerRight;
    }
    return BlocListener<SyncBloc, StateStatus>(
      listener: (BuildContext context, state) {
        if (state == StateStatus.LOADED) {
          context
              .read<CategoryBloc>()
              .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));

          context
              .read<TodayBloc>()
              .add(TodayEvent(requestEvent: CrudEventStatus.FETCH));
        }
      },
      child: BlocListener<CrudTaskBloc, CrudTaskState>(
        listener: (context, state) {
          if (state.requestState == StateStatus.LOADED) {
            context
                .read<CategoryBloc>()
                .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));

            context
                .read<TodayBloc>()
                .add(TodayEvent(requestEvent: CrudEventStatus.FETCH));
          }
        },
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Showcase(
                    showcaseBackgroundColor: themeColor.drowerLightBgClor,
                    textColor: themeColor.fgColor,
                    disposeOnTap: true,
                    onTargetClick: () {
                      Scaffold.of(context).openDrawer();
                    },
                    key: _thirth,
                    description: AppLocalizations.of(context)?.homed1 ?? '',
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 40,
                        color: themeColor.fgColor,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        context.read<HomeBloc>().add(HomeEvent.PROFILE);
                      },
                      child: ProfileImageWidget(size: 160, radius: 18)),
                ],
              ),
            ),
            Hero(
              tag: 'hero',
              child: SizedBox(
                width: width * .8,
                child: Transform.translate(
                  offset: Offset(0, -12),
                  child: Card(
                    color: themeColor.drowerBgClor,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              (AppLocalizations.of(context)?.welcome(
                                      widget.user?.displayName ?? '') ??
                                  ''),
                              style: TextStyle(
                                fontFamily: configuration.currentFont,
                                fontSize: 25,
                                color: themeColor.fgColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "${DateFormat('EEEE d MMMM', AppLocalizations.of(context)?.localeName).format(today)}",
                              style: TextStyle(
                                fontFamily: configuration.currentFont,
                                fontSize: 17,
                                color: themeColor.primaryLightColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: Container(
                      child: Text(
                        AppLocalizations.of(context)?.categories ?? '',
                        style: TextStyle(
                          fontFamily: configuration.currentFont,
                          fontSize: 30,
                          color: themeColor.fgColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Showcase(
                      showcaseBackgroundColor: themeColor.drowerLightBgClor,
                      textColor: themeColor.fgColor,
                      disposeOnTap: true,
                      onTargetClick: () {
                        Navigator.pushNamed(
                                widget.scaffoldKey.currentState!.context,
                                route.addCategoryPage)
                            .then((_) {
                          setState(() {
                            ShowCaseWidget.of(context)
                                .startShowCase([_second, _thirth]);
                          });
                        });
                      },
                      key: _first,
                      description: AppLocalizations.of(context)?.homed2 ?? '',
                      child: BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, state) {
                        switch (state.requestState) {
                          case StateStatus.LOADING:
                            return CustomLoadingProgress(
                                color: themeColor.primaryColor,
                                height: height * .4);
                          case StateStatus.LOADED:
                            if (state.categories?.isEmpty as bool) {
                              return Container(
                                constraints: const BoxConstraints(
                                  minHeight: 270,
                                  maxHeight: 270,
                                ),
                                height: height * .4,
                                child: NoDataFoundWidget(
                                  text: AppLocalizations.of(context)
                                          ?.nocategoryfound ??
                                      '',
                                  action: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, route.addCategoryPage);
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)
                                              ?.addCategory ??
                                          '',
                                      style: TextStyle(
                                        fontFamily: configuration.currentFont,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              constraints: const BoxConstraints(
                                minHeight: 260,
                                maxHeight: 260,
                              ),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.categories?.length,
                                itemBuilder: (context, index) {
                                  var category = state.categories?[index];
                                  double percent =
                                      (category?.numberTaskDone ?? 0) /
                                          (category?.numberTask ?? 0);
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, route.taskPage,
                                          arguments: category?.id);
                                    },
                                    child: Container(
                                      width: width * .49,
                                      child: Card(
                                        color: themeColor.primaryColor,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                alignment: alignment,
                                                child: Text(
                                                  "${category?.name?.toUpperCase()}",
                                                  style: TextStyle(
                                                      fontFamily: configuration
                                                          .currentFont,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 23),
                                                ),
                                              ),
                                            ),
                                            // const Spacer(),
                                            CustomProgress(
                                                percent: percent,
                                                radius: 110,
                                                lineWidth: 10,
                                                textSize: 23,
                                                themeColor: themeColor),
                                            const Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                alignment: alignment,
                                                child: Text(
                                                  (AppLocalizations.of(context)
                                                          ?.total(category
                                                                  ?.numberTask ??
                                                              0) ??
                                                      ''),
                                                  style: TextStyle(
                                                    fontFamily: configuration
                                                        .currentFont,
                                                    fontSize: 19,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );

                          default:
                            return Container();
                        }
                      }),
                    ),
                  ),
                  Showcase(
                    key: _second,
                    showcaseBackgroundColor: themeColor.drowerLightBgClor,
                    textColor: themeColor.fgColor,
                    description: AppLocalizations.of(context)?.homed3 ?? '',
                    child: BlocBuilder<TodayBloc, TodayState>(
                        builder: (context, state) {
                      switch (state.requestState) {
                        case StateStatus.LOADING:
                          return CustomLoadingProgress(
                              color: themeColor.primaryColor,
                              height: height * .4);
                        case StateStatus.LOADED:
                          if (state.todayTasks?.isEmpty as bool) {
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 5, 5),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                                  ?.todayTask ??
                                              '',
                                          style: TextStyle(
                                            fontFamily:
                                                configuration.currentFont,
                                            fontSize: 30,
                                            color: themeColor.fgColor,
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: height * .3,
                                    child: Center(
                                        child: Opacity(
                                            opacity: .9,
                                            child: Lottie.asset(
                                                'assets/lotties/calendar_lottie_animation.json',
                                                width: width * .8)))),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 5),
                                child: Container(
                                  // alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width * .5,
                                        child: FittedBox(
                                          alignment: alignment,
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            AppLocalizations.of(context)
                                                    ?.todayTask ??
                                                '',
                                            style: TextStyle(
                                              fontFamily:
                                                  configuration.currentFont,
                                              fontSize: 30,
                                              color: themeColor.fgColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        AppLocalizations.of(context)?.tasks(
                                                state.todayTasks?.length
                                                    as int) ??
                                            '',
                                        style: TextStyle(
                                          fontFamily: configuration.currentFont,
                                          fontSize: 30,
                                          color: themeColor.fgColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * .4,
                                child: ListView.builder(
                                  itemCount: state.todayTasks?.length,
                                  itemBuilder: (context, index) {
                                    final task = state.todayTasks?[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Card(
                                            elevation: 1,
                                            shadowColor: themeColor.fgColor,
                                            color: themeColor.drowerBgClor,
                                            child: ListTile(
                                              selectedColor:
                                                  themeColor.primaryColor,
                                              leading: IconButton(
                                                icon: task?.status ==
                                                        TaskStatus.DONE
                                                    ? Icon(
                                                        Icons.check_circle,
                                                        size: 30,
                                                        color: themeColor
                                                            .secondaryColor,
                                                      )
                                                    : Icon(
                                                        Icons.circle_outlined,
                                                        size: 30,
                                                        color: themeColor
                                                            .secondaryColor,
                                                      ),
                                                onPressed: () {
                                                  if (task?.status !=
                                                      TaskStatus.DONE) {
                                                    var _task = task;
                                                    _task?.status =
                                                        TaskStatus.DONE;
                                                    context
                                                        .read<CrudTaskBloc>()
                                                        .add(CrudTaskEvent(
                                                            requestEvent:
                                                                CrudEventStatus
                                                                    .EDIT,
                                                            task: _task));
                                                    context
                                                        .read<TodayBloc>()
                                                        .add(TodayEvent(
                                                            requestEvent:
                                                                CrudEventStatus
                                                                    .FETCH));
                                                    context
                                                        .read<CategoryBloc>()
                                                        .add(CategoryEvent(
                                                            requestEvent:
                                                                CrudEventStatus
                                                                    .FETCH));
                                                    context
                                                        .read<CrudTaskBloc>()
                                                        .add(CrudTaskEvent(
                                                            requestEvent:
                                                                CrudEventStatus
                                                                    .RESET));
                                                  }
                                                },
                                              ),
                                              trailing: task?.status ==
                                                      TaskStatus.DONE
                                                  ? IconButton(
                                                      icon: Icon(
                                                        Icons.close,
                                                        size: 30,
                                                        color: themeColor
                                                            .secondaryColor,
                                                      ),
                                                      onPressed: () {
                                                        var _task = task;
                                                        _task?.showInToday =
                                                            false;
                                                        context
                                                            .read<
                                                                CrudTaskBloc>()
                                                            .add(CrudTaskEvent(
                                                                requestEvent:
                                                                    CrudEventStatus
                                                                        .EDIT,
                                                                task: _task));
                                                        context
                                                            .read<TodayBloc>()
                                                            .add(TodayEvent(
                                                                requestEvent:
                                                                    CrudEventStatus
                                                                        .FETCH));
                                                        context
                                                            .read<
                                                                CrudTaskBloc>()
                                                            .add(CrudTaskEvent(
                                                                requestEvent:
                                                                    CrudEventStatus
                                                                        .RESET));
                                                      },
                                                    )
                                                  : null,
                                              textColor: themeColor.fgColor,
                                              title: Row(
                                                children: [
                                                  Text(
                                                    task?.title ?? '',
                                                    style: TextStyle(
                                                      fontFamily: configuration
                                                          .currentFont,
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    EnumTranslateServices
                                                        .translateTaskStatus(
                                                            context,
                                                            task?.status
                                                                as TaskStatus),
                                                    style: TextStyle(
                                                      fontFamily: configuration
                                                          .currentFont,
                                                      color: themeColor
                                                          .secondaryColor,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );

                        default:
                          return Container();
                      }
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
