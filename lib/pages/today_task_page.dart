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
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/widgets/custom_appbar_widget.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/no_data_found_widget.dart';

class TodayPage extends StatefulWidget {
  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage>
    with SingleTickerProviderStateMixin {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  int taskNbr = 0;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeColor.bgColor,
      body: Column(
        children: [
          CustomAppBar(title: ''),
          SizedBox(
            height: height * .15,
            width: width * .95,
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
                        WavyAnimatedText('Today you have '),
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                    ),
                  ),
                  Text(
                    "$taskNbr tasks ",
                    style: TextStyle(
                      color: themeColor.primaryLightColor,
                      fontSize: 22,
                    ),
                  ),
                ],
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
                  alignment: Alignment.centerLeft,
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
      'status': 'Passed',
      'color': themeColor.errorColor
    };
    var now = DateTime.now();
    if (start.compareTo(now) > 0) {
      data = {'status': 'Coming', 'color': themeColor.secondaryColor};
    }
    if (start.compareTo(now) < 0 && end.compareTo(now) > 0) {
      data = {'status': 'Started', 'color': themeColor.primaryLightColor};
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
              EnumToString.convertToString(item).toLowerCase(),
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