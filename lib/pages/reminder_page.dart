import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/reminder/reminder_bloc.dart';
import 'package:microtask/blocs/reminder/reminder_event.dart';
import 'package:microtask/blocs/reminder/reminder_state.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/widgets/no_data_found_widget.dart';

class ReminderPage extends StatefulWidget {
  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  int currenIndex = 0;
  @override
  void initState() {
    super.initState();
    context
        .read<ReminderBloc>()
        .add(ReminderEvent(requestEvent: ReminderEventStatus.TODAY));
  }

  test() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeColor.bgColor,
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                              left: 0, top: 10, bottom: 10),
                          child: Icon(Icons.keyboard_arrow_left,
                              color: themeColor.fgColor),
                        ),
                        Text('Back',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: themeColor.fgColor)),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Text('Reminders',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: themeColor.fgColor)),
                const Spacer(),
                FloatingActionButton(
                  tooltip: 'Refresh',
                  backgroundColor: themeColor.primaryColor,
                  onPressed: () {
                    if (currenIndex == 0) {
                      context.read<ReminderBloc>().add(ReminderEvent(
                          requestEvent: ReminderEventStatus.TODAY));
                    } else {
                      context.read<ReminderBloc>().add(ReminderEvent(
                          requestEvent: ReminderEventStatus.INCOMING));
                    }
                  },
                  child: const Icon(
                    Icons.restart_alt,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: StatefulBuilder(builder: (context, setInnerState) {
              return DefaultTabController(
                length: 2,
                initialIndex: currenIndex,
                child: TabBar(
                  onTap: (value) {
                    if (value != currenIndex) {
                      if (value == 0) {
                        context.read<ReminderBloc>().add(ReminderEvent(
                            requestEvent: ReminderEventStatus.TODAY));
                      } else {
                        context.read<ReminderBloc>().add(ReminderEvent(
                            requestEvent: ReminderEventStatus.INCOMING));
                      }
                    }
                    setInnerState(() {
                      currenIndex = value;
                    });
                  },
                  indicatorColor: currenIndex == 0
                      ? themeColor.secondaryColor
                      : themeColor.secondaryColor,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.today,
                        color: currenIndex == 0
                            ? themeColor.secondaryColor
                            : themeColor.fgColor,
                        size: 30,
                      ),
                      child: Text('ToDay',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: currenIndex == 0
                                  ? themeColor.secondaryColor
                                  : themeColor.fgColor)),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.info_outline,
                        color: currenIndex == 1
                            ? themeColor.secondaryColor
                            : themeColor.fgColor,
                        size: 30,
                      ),
                      child: Text('Incoming',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: currenIndex == 1
                                  ? themeColor.secondaryColor
                                  : themeColor.fgColor)),
                    ),
                  ],
                ),
              );
            }),
          ),
          Expanded(
            child: BlocBuilder<ReminderBloc, ReminderState>(
                builder: (context, state) {
              switch (state.requestSatus) {
                case StateStatus.LOADING:
                  return Container(
                    height: height * .75,
                    child: Center(
                      child: SpinKitSpinningLines(
                          lineWidth: 5, color: themeColor.primaryColor),
                    ),
                  );
                case StateStatus.ERROR:
                  return SizedBox(
                    child: NoDataFoundWidget(
                      text: state.errormessage ?? '',
                      textColor: themeColor.errorColor,
                    ),
                  );
                case StateStatus.LOADED:
                  if (state.tasks?.isEmpty as bool) {
                    return SizedBox(
                      child: NoDataFoundWidget(
                        text: 'Not task found',
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.tasks?.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks?[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            task?.reminder = !task.reminder!;
                            context.read<CrudTaskBloc>().add(CrudTaskEvent(
                                requestEvent: CrudEventStatus.EDIT,
                                task: task));
                            if (currenIndex == 0) {
                              context.read<ReminderBloc>().add(ReminderEvent(
                                  requestEvent: ReminderEventStatus.TODAY));
                            } else {
                              context.read<ReminderBloc>().add(ReminderEvent(
                                  requestEvent: ReminderEventStatus.INCOMING));
                            }
                          },
                          child: Card(
                            color: themeColor.drowerBgClor,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: ListTile(
                                leading: Icon(
                                  Icons.alarm,
                                  size: 40,
                                  color: task?.reminder as bool
                                      ? themeColor.secondaryColor
                                      : themeColor.fgColor,
                                ),
                                trailing: Switch(
                                  activeColor: themeColor.secondaryColor,
                                  onChanged: (value) {
                                    task?.reminder = !task.reminder!;
                                    context.read<CrudTaskBloc>().add(
                                        CrudTaskEvent(
                                            requestEvent: CrudEventStatus.EDIT,
                                            task: task));
                                    if (currenIndex == 0) {
                                      context.read<ReminderBloc>().add(
                                          ReminderEvent(
                                              requestEvent:
                                                  ReminderEventStatus.TODAY));
                                    } else {
                                      context.read<ReminderBloc>().add(
                                          ReminderEvent(
                                              requestEvent: ReminderEventStatus
                                                  .INCOMING));
                                    }
                                  },
                                  value: task?.reminder as bool,
                                ),
                                title: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(task?.title ?? '',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              color: themeColor.fgColor)),
                                      Text(
                                          'Start at : ${DateFormat("yyyy MM dd hh:mm:ss").format(task?.startDateTime as DateTime)}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: themeColor.primaryColor)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );

                default:
                  return Container();
              }
            }),
          )
        ],
      ),
    );
  }
}
