import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/today/today_bloc.dart';
import 'package:microtask/blocs/today/today_event.dart';
import 'package:microtask/blocs/today/today_state.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/services/enum_translate_services.dart';
import 'package:microtask/widgets/custom_appbar_widget.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/no_data_found_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TodayPage extends StatefulWidget {
  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage>
    with SingleTickerProviderStateMixin {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();
  final List<GlobalKey> _list = [
    GlobalKey(),
    GlobalKey(),
  ];
  Alignment alignment = Alignment.centerLeft;

  @override
  initState() {
    super.initState();
    if (showCaseConfig.isLunched(route.todayPage)) {
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
    if (AppLocalizations.of(context)?.localeName == 'ar') {
      alignment = Alignment.centerRight;
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeColor.bgColor,
      body: Column(
        children: [
          CustomAppBar(title: ''),
          SizedBox(
            height: height * .15,
            width: width * .95,
            child: Showcase(
              key: _list[0],
              showcaseBackgroundColor: themeColor.drowerLightBgClor,
              textColor: themeColor.fgColor,
              description: AppLocalizations.of(context)?.todayd1 ?? '',
              child: Card(
                elevation: 0,
                color: themeColor.drowerBgClor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(
                        color: themeColor.fgColor,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          WavyAnimatedText(
                              AppLocalizations.of(context)?.todayYouHave ?? ''),
                        ],
                        isRepeatingAnimation: true,
                        repeatForever: true,
                      ),
                    ),
                    BlocBuilder<TodayBloc, TodayState>(
                        builder: (context, state) {
                      if (state.requestState == StateStatus.LOADED) {
                        return Text(
                          AppLocalizations.of(context)
                                  ?.tasks(state.todayTasks?.length as int) ??
                              '',
                          style: TextStyle(
                            color: themeColor.primaryLightColor,
                            fontSize: 22,
                          ),
                        );
                      } else {
                        return Text(
                          AppLocalizations.of(context)?.tasks(0) ?? '',
                          style: TextStyle(
                            color: themeColor.primaryLightColor,
                            fontSize: 22,
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
          BlocBuilder<TodayBloc, TodayState>(builder: (context, state) {
            switch (state.requestState) {
              case StateStatus.LOADING:
                return CustomLoadingProgress(
                    color: themeColor.primaryColor, height: height * .4);
              case StateStatus.LOADED:
                if (state.todayTasks?.isEmpty as bool) {
                  return Expanded(
                    child: Center(
                        child: Opacity(
                            opacity: .9,
                            child: Lottie.asset(
                                'assets/lotties/no_data_found.json',
                                width: width * .8))),
                  );
                }
                List<Widget> list = [];
                for (var task in state.todayTasks!) {
                  list.add(_getItem(task));
                }

                return Expanded(
                  child: SizedBox(
                    width: width * .95,
                    child: Card(
                      color: themeColor.bgColor,
                      child: ListView(itemExtent: 240, children: list),
                    ),
                  ),
                );
              default:
                return Container();
            }
          }),
        ],
      ),
    );
  }

  Widget _getItem(Task task) {
    return Card(
      color: themeColor.drowerBgClor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          ListTile(
            trailing: PopupMenuButton(
                color: themeColor.drowerLightBgClor,
                child: Icon(
                  Icons.more_vert,
                  size: 30,
                  color: themeColor.fgColor,
                ),
                itemBuilder: (context) => getMenuItems(task)),
            title: Text(
              "${task.title?.toUpperCase()}",
              style: TextStyle(
                color: themeColor.primaryColor,
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Container(
              constraints: BoxConstraints(maxHeight: 100),
              child: SingleChildScrollView(
                child: Container(
                  alignment: alignment,
                  child: Text(
                    "         ${task.description}",
                    style: TextStyle(
                      color: themeColor.fgColor,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          _getListTile(task.startDateTime!, task.endDateTime!),
        ]),
      ),
    );
  }

  Widget _getListTile(DateTime start, DateTime end) {
    Map<String, dynamic> data = {
      'status': AppLocalizations.of(context)?.passed ?? '',
      'color': themeColor.errorColor
    };
    var now = DateTime.now();
    if (start.compareTo(now) > 0) {
      data = {
        'status': AppLocalizations.of(context)?.coming ?? '',
        'color': themeColor.secondaryColor
      };
    }
    if (start.compareTo(now) < 0 && end.compareTo(now) > 0) {
      data = {
        'status': AppLocalizations.of(context)?.started ?? '',
        'color': themeColor.primaryLightColor
      };
    }
    return ListTile(
      trailing: Text(
        "${data['status']}",
        style: TextStyle(
          color: data['color'],
          fontSize: 18,
        ),
      ),
      title: Text(
        "${DateFormat("HH:mm:ss").format(start)}",
        style: TextStyle(
          color: data['color'],
          fontSize: 18,
        ),
      ),
    );
  }

  List<PopupMenuEntry> getMenuItems(Task task) {
    List<PopupMenuEntry> list = [];
    int counter = 0;
    for (var item in TaskStatus.values) {
      if (item != task.status) {
        list.add(
          PopupMenuItem(
            onTap: () {
              var _task = task;
              _task.status = item;
              context.read<CrudTaskBloc>().add(CrudTaskEvent(
                  requestEvent: CrudEventStatus.EDIT, task: _task));
              context
                  .read<TodayBloc>()
                  .add(TodayEvent(requestEvent: CrudEventStatus.FETCH));
              context
                  .read<CategoryBloc>()
                  .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));
              context
                  .read<CrudTaskBloc>()
                  .add(CrudTaskEvent(requestEvent: CrudEventStatus.RESET));
            },
            child: Text(
              EnumTranslateServices.translateTaskStatus(context, item),
              style: TextStyle(color: themeColor.fgColor),
            ),
            value: counter,
          ),
        );
        counter++;
      }
    }
    return list;
  }
}
