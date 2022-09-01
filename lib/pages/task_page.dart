import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/crud_task/crud_task_state.dart';
import 'package:microtask/blocs/date/date_bloc.dart';
import 'package:microtask/blocs/reminder/reminder_bloc.dart';
import 'package:microtask/blocs/reminder/reminder_event.dart';
import 'package:microtask/blocs/task/task_bloc.dart';
import 'package:microtask/blocs/task/task_event.dart';
import 'package:microtask/blocs/task/task_state.dart';
import 'package:microtask/blocs/today/today_bloc.dart';
import 'package:microtask/blocs/today/today_event.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/models/drag_data.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/services/enum_translate_services.dart';
import 'package:microtask/services/notification_service.dart';
import 'package:microtask/widgets/custom_appbar_widget.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/custom_snakbar_widget.dart';
import 'package:microtask/widgets/no_data_found_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

DateTime currentDate = DateTime.now();
bool isTaskMenuOpen = false;
Function? _taskMenuInnerState;
Function? _cardInnerState;
Function? _parentState;
Color? cardColor;
late AnimationController _controller1;
Task? GTask;

class TaskPage extends StatefulWidget {
  String categoryId;
  TaskPage({required this.categoryId});
  @override
  State<TaskPage> createState() => _TaskPageState();
}

bool _isDragging = false;

class _TaskPageState extends State<TaskPage>
    with SingleTickerProviderStateMixin {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  Configuration get configuration => GetIt.I<Configuration>();
  NotificationServices get notificationServices =>
      GetIt.I<NotificationServices>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  double height = 0;
  double width = 0;
  ScrollController _scrollController = ScrollController();
  List<DateTime> list = [];
  final ScrollController _scroller = ScrollController();
  final _listViewKey = GlobalKey();
  genrateList(DateTime date) {
    var startFrom = date.subtract(Duration(days: date.weekday - 1));
    list = List.generate(7, (i) => startFrom.add(Duration(days: i)));
  }

  bool isGlobaleMenuOpen = false;

  Function? _globalMenuInnerState;

  @override
  void initState() {
    super.initState();
    cardColor = themeColor.drowerBgClor;
    genrateList(DateTime.now());
    context.read<TaskBloc>().add(TaskEvent(
        requestEvent: CrudEventStatus.FETCH,
        date: currentDate,
        categoryId: widget.categoryId));
    if (showCaseConfig.isLunched(route.taskPage)) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(const Duration(seconds: 1))
            .then((value) => ShowCaseWidget.of(context).startShowCase(_list)),
      );
    }
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _parentState = setState;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    var calenderHeigth = height * .16;
    if (height < 450) {
      calenderHeigth = height * .26;
    }
    return Scaffold(
      backgroundColor: themeColor.bgColor,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 14,
              ),
              Showcase(
                  key: _list[0],
                  showcaseBackgroundColor: themeColor.drowerLightBgClor,
                  textColor: themeColor.fgColor,
                  description: AppLocalizations.of(context)?.tasksd1 ?? '',
                  child: CustomAppBar(
                    title: AppLocalizations.of(context)?.taskPage ?? '',
                    action: _buttonsActions(),
                  )),
              BlocListener<CrudTaskBloc, CrudTaskState>(
                listener: (BuildContext context, state) {
                  context.read<TaskBloc>().add(TaskEvent(
                      requestEvent: CrudEventStatus.FETCH,
                      date: currentDate,
                      categoryId: widget.categoryId));
                },
                child: Expanded(
                    child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      Visibility(
                          visible: configuration.showHearder!,
                          child: Column(
                            children: [
                              BlocBuilder<DateBloc, DateState>(
                                  builder: (context, state) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 5, 10),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            '${DateFormat(" MMMM", AppLocalizations.of(context)?.localeName ?? '').format(state.date)} ${DateFormat(
                                              "dd ",
                                            ).format(state.date)}',
                                            style: TextStyle(
                                                fontFamily:
                                                    configuration.currentFont,
                                                fontSize: 28,
                                                fontWeight: FontWeight.w500,
                                                color: themeColor.fgColor)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 10),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            const Spacer(),
                                            Text(
                                                '${DateFormat("EEEE", AppLocalizations.of(context)?.localeName ?? '').format(state.date)}',
                                                style: TextStyle(
                                                    fontFamily: configuration
                                                        .currentFont,
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.w500,
                                                    color: themeColor
                                                        .secondaryColor)),
                                            const Spacer(),
                                            Showcase(
                                              key: _list[3],
                                              showcaseBackgroundColor:
                                                  themeColor.drowerLightBgClor,
                                              textColor: themeColor.fgColor,
                                              description:
                                                  AppLocalizations.of(context)
                                                          ?.tasksd2 ??
                                                      '',
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      route.addTaskPage,
                                                      arguments: {
                                                        'categoryId':
                                                            widget.categoryId,
                                                        'rotate': true
                                                      });
                                                },
                                                child: Container(
                                                  height: 60,
                                                  width: 100,
                                                  child: Card(
                                                    color:
                                                        themeColor.primaryColor,
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                        context)
                                                                    ?.categoriesAdd ??
                                                                '',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    configuration
                                                                        .currentFont,
                                                                fontSize: 28,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              Showcase(
                                key: _list[4],
                                showcaseBackgroundColor:
                                    themeColor.drowerLightBgClor,
                                textColor: themeColor.fgColor,
                                description:
                                    AppLocalizations.of(context)?.tasksd3 ?? '',
                                child: SizedBox(
                                  height: calenderHeigth,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: BlocBuilder<DateBloc, DateState>(
                                        builder: (context, state) {
                                      genrateList(state.date);
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 7,
                                        itemBuilder: (context, index) {
                                          final date = DateTime(
                                              list[index].year,
                                              list[index].month,
                                              list[index].day);
                                          Color currentColor =
                                              themeColor.primaryColor;
                                          if (date == state.date)
                                            currentColor =
                                                themeColor.secondaryColor;
                                          return Row(
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  currentDate = date;
                                                  context.read<DateBloc>().add(
                                                      DateEvent(date: date));
                                                  context.read<TaskBloc>().add(
                                                      TaskEvent(
                                                          requestEvent:
                                                              CrudEventStatus
                                                                  .FETCH,
                                                          date: date,
                                                          categoryId: widget
                                                              .categoryId));
                                                },
                                                child: Container(
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: currentColor,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              '${DateFormat("MMM", AppLocalizations.of(context)?.localeName ?? '').format(list[index])}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      configuration
                                                                          .currentFont,
                                                                  fontSize: 20,
                                                                  color:
                                                                      currentColor)),
                                                          Text(
                                                              '${DateFormat("dd").format(list[index])}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      configuration
                                                                          .currentFont,
                                                                  fontSize: 20,
                                                                  color:
                                                                      currentColor)),
                                                          Text(
                                                              '${DateFormat("EEE", AppLocalizations.of(context)?.localeName ?? '').format(list[index])}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      configuration
                                                                          .currentFont,
                                                                  fontSize: 20,
                                                                  color:
                                                                      currentColor)),
                                                        ]),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
                        child: Container(
                          child: Row(
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                    AppLocalizations.of(context)?.taskManager ??
                                        '',
                                    style: TextStyle(
                                        fontFamily: configuration.currentFont,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: themeColor.fgColor)),
                              ),
                              const Spacer(),
                              StatefulBuilder(
                                  builder: (context, setInnerState) {
                                return BlocListener<DateBloc, DateState>(
                                  listener: (context, state) {
                                    setInnerState(() {});
                                  },
                                  child: Visibility(
                                    visible: !configuration.showHearder!,
                                    child: Text(
                                        DateFormat(
                                                    "EEEE",
                                                    AppLocalizations.of(context)
                                                        ?.localeName)
                                                .format(currentDate) +
                                            ' ' +
                                            DateFormat("dd")
                                                .format(currentDate) +
                                            ' ' +
                                            DateFormat(
                                                    "MMMM",
                                                    AppLocalizations.of(context)
                                                        ?.localeName)
                                                .format(currentDate),
                                        style: TextStyle(
                                            fontFamily:
                                                configuration.currentFont,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                themeColor.primaryLightColor)),
                                  ),
                                );
                              }),
                              const Spacer(),
                              Visibility(
                                visible: !configuration.showHearder!,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, route.addTaskPage, arguments: {
                                      'categoryId': widget.categoryId,
                                      'rotate': true
                                    });
                                  },
                                  icon: Icon(Icons.add,
                                      color: themeColor.primaryColor, size: 35),
                                ),
                              ),
                              Showcase(
                                key: _list[6],
                                disposeOnTap: true,
                                onTargetClick: () {
                                  _scrollController.jumpTo(height / 2);
                                  if (!showCaseConfig
                                      .isLunched(route.taskPage + '6')) {
                                    WidgetsBinding.instance
                                        ?.addPostFrameCallback(
                                      (_) => ShowCaseWidget.of(context)
                                          .startShowCase([_list[7]]),
                                    );
                                  }
                                },
                                showcaseBackgroundColor:
                                    themeColor.drowerLightBgClor,
                                textColor: themeColor.fgColor,
                                description:
                                    AppLocalizations.of(context)?.tasksd4 ?? '',
                                child: IconButton(
                                  onPressed: () {
                                    context.read<TaskBloc>().add(TaskEvent(
                                        requestEvent: CrudEventStatus.FETCH,
                                        date: currentDate,
                                        categoryId: widget.categoryId));
                                  },
                                  icon: Icon(Icons.refresh_outlined,
                                      color: themeColor.primaryColor, size: 35),
                                ),
                              ),
                              Showcase(
                                key: _list[5],
                                showcaseBackgroundColor:
                                    themeColor.drowerLightBgClor,
                                textColor: themeColor.fgColor,
                                description:
                                    AppLocalizations.of(context)?.tasksd5 ?? '',
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      configuration.showHearder =
                                          !configuration.showHearder!;
                                    });
                                    _scrollController.jumpTo(0);
                                  },
                                  icon: Icon(
                                      configuration.showHearder!
                                          ? Icons
                                              .keyboard_double_arrow_up_outlined
                                          : Icons.keyboard_double_arrow_down,
                                      color: configuration.showHearder!
                                          ? themeColor.primaryColor
                                          : themeColor.errorColor,
                                      size: 35),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      BlocBuilder<TaskBloc, TaskState>(
                          builder: (context, state) {
                        switch (state.requestState) {
                          case StateStatus.LOADING:
                            return CustomLoadingProgress(
                                color: themeColor.primaryColor,
                                height: height * .8);
                          case StateStatus.ERROR:
                            return NoDataFoundWidget(
                              text: state.errormessage ?? '',
                            );
                          case StateStatus.LOADED:
                            return Container(
                              height: height * .8,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: _createListener(
                                    ListView(
                                      key: _listViewKey,
                                      padding: EdgeInsets.zero,
                                      controller: _scroller,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Showcase(
                                          key: _list[7],
                                          disposeOnTap: true,
                                          onTargetClick: () {
                                            if (!showCaseConfig.isLunched(
                                                route.taskPage + '7')) {
                                              WidgetsBinding.instance
                                                  ?.addPostFrameCallback(
                                                (_) => ShowCaseWidget.of(
                                                        context)
                                                    .startShowCase([_list[8]]),
                                              );
                                            }
                                          },
                                          showcaseBackgroundColor:
                                              themeColor.drowerLightBgClor,
                                          textColor: themeColor.fgColor,
                                          description:
                                              AppLocalizations.of(context)
                                                      ?.tasksd6 ??
                                                  '',
                                          child: MyColumn(
                                              themeColor: themeColor,
                                              gradient: LinearGradient(
                                                colors: swapColors([
                                                  const Color.fromARGB(
                                                      255, 255, 128, 0),
                                                  const Color.fromARGB(
                                                      255, 255, 252, 59),
                                                ]),
                                              ),
                                              title: EnumTranslateServices
                                                  .translateTaskStatus(
                                                      context, TaskStatus.TODO),
                                              status: TaskStatus.TODO,
                                              list: state.todoTasks!),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Showcase(
                                          key: _list[8],
                                          disposeOnTap: true,
                                          onTargetClick: () {
                                            _scroller.jumpTo(_scroller.offset +
                                                (width * .61));
                                            if (!showCaseConfig.isLunched(
                                                route.taskPage + '8')) {
                                              WidgetsBinding.instance
                                                  ?.addPostFrameCallback(
                                                (_) => ShowCaseWidget.of(
                                                        context)
                                                    .startShowCase([_list[9]]),
                                              );
                                            }
                                          },
                                          showcaseBackgroundColor:
                                              themeColor.drowerLightBgClor,
                                          textColor: themeColor.fgColor,
                                          description:
                                              AppLocalizations.of(context)
                                                      ?.tasksd7 ??
                                                  '',
                                          child: MyColumn(
                                              themeColor: themeColor,
                                              gradient: LinearGradient(
                                                colors: swapColors([
                                                  const Color.fromARGB(
                                                      255, 255, 252, 59),
                                                  const Color.fromARGB(
                                                      255, 111, 255, 0),
                                                ]),
                                              ),
                                              title: EnumTranslateServices
                                                  .translateTaskStatus(context,
                                                      TaskStatus.DOING),
                                              status: TaskStatus.DOING,
                                              list: state.doingTasks!),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Showcase(
                                          key: _list[9],
                                          disposeOnTap: true,
                                          onTargetClick: () {
                                            if (!showCaseConfig.isLunched(
                                                route.taskPage + '9')) {
                                              ShowCaseWidget.of(context)
                                                  .startShowCase([_list[10]]);
                                            }
                                          },
                                          showcaseBackgroundColor:
                                              themeColor.drowerLightBgClor,
                                          textColor: themeColor.fgColor,
                                          description:
                                              AppLocalizations.of(context)
                                                      ?.tasksd8 ??
                                                  '',
                                          child: MyColumn(
                                              themeColor: themeColor,
                                              gradient: LinearGradient(
                                                colors: swapColors([
                                                  const Color.fromARGB(
                                                      255, 111, 255, 0),
                                                  const Color.fromARGB(
                                                      255, 59, 154, 255),
                                                ]),
                                              ),
                                              title: EnumTranslateServices
                                                  .translateTaskStatus(
                                                      context, TaskStatus.DONE),
                                              status: TaskStatus.DONE,
                                              list: state.doneTasks!),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Showcase(
                                          key: _list[10],
                                          showcaseBackgroundColor:
                                              themeColor.drowerLightBgClor,
                                          textColor: themeColor.fgColor,
                                          description:
                                              AppLocalizations.of(context)
                                                      ?.tasksd9 ??
                                                  '',
                                          child: MyColumn(
                                              themeColor: themeColor,
                                              gradient: LinearGradient(
                                                colors: swapColors([
                                                  const Color.fromARGB(
                                                      255, 59, 154, 255),
                                                  const Color.fromARGB(
                                                      255, 255, 0, 115),
                                                ]),
                                              ),
                                              title: EnumTranslateServices
                                                  .translateTaskStatus(context,
                                                      TaskStatus.UNDONE),
                                              status: TaskStatus.UNDONE,
                                              list: state.undoneTasks!),
                                        ),
                                      ],
                                    ),
                                  )),
                            );

                          default:
                            return Container();
                        }
                      })
                    ],
                  ),
                )),
              )
            ],
          ),
          _menuButton(),
          StatefulBuilder(builder: (context, setInnerState) {
            _globalMenuInnerState = setInnerState;
            return Visibility(visible: isGlobaleMenuOpen, child: _globalMenu());
          }),
          StatefulBuilder(builder: (context, setInnerState) {
            _taskMenuInnerState = setInnerState;
            return Visibility(visible: isTaskMenuOpen, child: _taskMenu());
          }),
        ],
      ),
    );
  }

  Widget _taskMenu() {
    return StatefulBuilder(builder: (context, setInnerState) {
      return GestureDetector(
        onTap: () {
          _controller1.reverse().then((value) {
            if (_taskMenuInnerState != null) {
              _taskMenuInnerState!(() {
                isTaskMenuOpen = false;
              });
            }
          });
          _cardInnerState!(() {
            cardColor = themeColor.drowerBgClor;
          });
        },
        child: Container(
          color: Colors.transparent,
          height: height,
          width: width,
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(width * .88, height * .25, 0, height * .25),
            child: AnimatedBuilder(
                animation: _controller1,
                child: Card(
                  color: themeColor.drowerBgClor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, route.showTaskPage,
                                arguments: {
                                  'taskId': GTask?.id,
                                  'rotate': true
                                });
                          },
                          icon: Icon(
                            Icons.remove_red_eye_outlined,
                            size: 30,
                            color: themeColor.primaryLightColor,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GTask?.noteId == null
                            ? IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, route.addNotePage, arguments: {
                                    'task': GTask,
                                    'rotate': true
                                  }).then((value) {
                                    _controller1.reverse().then((value) {
                                      if (_taskMenuInnerState != null) {
                                        _taskMenuInnerState!(() {
                                          isTaskMenuOpen = false;
                                        });
                                      }
                                    });
                                    _cardInnerState!(() {
                                      cardColor = themeColor.drowerBgClor;
                                    });
                                  });
                                },
                                icon: Icon(
                                  Icons.note_add_outlined,
                                  size: 30,
                                  color: themeColor.primaryColor,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, route.notePage,
                                      arguments: {
                                        'noteId': GTask?.noteId,
                                        'rotate': true
                                      });
                                },
                                icon: Icon(
                                  Icons.note_alt_rounded,
                                  size: 30,
                                  color: themeColor.secondaryColor,
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        GTask?.repeatType == null
                            ? Icon(
                                Icons.alarm_on_outlined,
                                size: 30,
                                color: themeColor.fgColor.withOpacity(.6),
                              )
                            : GTask?.reminder as bool
                                ? IconButton(
                                    onPressed: () {
                                      GTask?.reminder = false;
                                      context.read<CrudTaskBloc>().add(
                                          CrudTaskEvent(
                                              requestEvent:
                                                  CrudEventStatus.EDIT,
                                              task: GTask));
                                      setInnerState(() {});
                                    },
                                    icon: Icon(
                                      Icons.alarm_on,
                                      size: 30,
                                      color: themeColor.secondaryColor,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      GTask?.reminder = true;
                                      context.read<CrudTaskBloc>().add(
                                          CrudTaskEvent(
                                              requestEvent:
                                                  CrudEventStatus.EDIT,
                                              task: GTask));
                                      setInnerState(() {});
                                    },
                                    icon: Icon(
                                      Icons.alarm_off_outlined,
                                      size: 30,
                                      color: themeColor.errorColor,
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                        (width * .12) - ((width * .12) * _controller1.value),
                        0),
                    child: child,
                  );
                }),
          ),
        ),
      );
    });
  }

  Widget _globalMenu() {
    return GestureDetector(
      onTap: () {
        _controller1.reverse().then((value) {
          if (_globalMenuInnerState != null) {
            _globalMenuInnerState!(() {
              isGlobaleMenuOpen = false;
            });
          }
        });
      },
      child: Container(
        color: Colors.transparent,
        height: height,
        width: width,
        child: Padding(
          padding:
              EdgeInsets.fromLTRB(0, height * .23, width * .88, height * .23),
          child: AnimatedBuilder(
              animation: _controller1,
              child: Card(
                elevation: 4,
                color: themeColor.drowerBgClor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, route.notesPage,
                                  arguments: true)
                              .then((value) {
                            _parentState!(() {});
                          });
                        },
                        icon: Icon(
                          Icons.note_alt_rounded,
                          size: 37,
                          color: themeColor.secondaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, route.todayPage);
                        },
                        icon: Icon(
                          Icons.today,
                          size: 37,
                          color: themeColor.primaryLightColor,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, route.reminderPage);
                        },
                        icon: Icon(
                          Icons.alarm_outlined,
                          size: 37,
                          color: themeColor.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                      -(width * .12) +
                          (((width * .12) - 5) * _controller1.value),
                      0),
                  child: child,
                );
              }),
        ),
      ),
    );
  }

  Widget _menuButton() {
    return Positioned(
      top: height * .35,
      left: -10,
      child: Container(
        height: 60,
        width: 40,
        child: GestureDetector(
          onTap: () {
            if (_globalMenuInnerState != null) {
              _globalMenuInnerState!(() {
                isGlobaleMenuOpen = true;
                _controller1.forward();
              });
            }
          },
          child: Card(
            color: themeColor.primaryColor,
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  List<Color> swapColors(List<Color> colors) {
    if ((AppLocalizations.of(context)?.localeName ?? '') == 'ar') {
      return [colors[1], colors[0]];
    }
    return colors;
  }

  Widget _buttonsActions() {
    return Row(
      children: [
        Showcase(
          key: _list[1],
          shapeBorder: const CircleBorder(),
          showcaseBackgroundColor: themeColor.drowerLightBgClor,
          textColor: themeColor.fgColor,
          description: AppLocalizations.of(context)?.tasksd10 ?? '',
          child: FloatingActionButton(
            heroTag: 'today',
            mini: true,
            tooltip: AppLocalizations.of(context)?.today ?? '',
            backgroundColor: themeColor.secondaryColor,
            onPressed: () {
              currentDate = DateTime.now();
              context.read<DateBloc>().add(DateEvent(
                  date: DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)));
              context.read<TaskBloc>().add(TaskEvent(
                  requestEvent: CrudEventStatus.FETCH,
                  date: DateTime.now(),
                  categoryId: widget.categoryId));
            },
            child: const Icon(
              Icons.calendar_today_outlined,
              size: 25,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Showcase(
          key: _list[2],
          shapeBorder: const CircleBorder(),
          showcaseBackgroundColor: themeColor.drowerLightBgClor,
          textColor: themeColor.fgColor,
          description: AppLocalizations.of(context)?.tasksd11 ?? '',
          child: FloatingActionButton(
            heroTag: 'date',
            mini: true,
            tooltip: AppLocalizations.of(context)?.chooseDate ?? '',
            onPressed: () async {
              DateTime? date = await showDatePicker(
                  context: context,
                  locale:
                      Locale(AppLocalizations.of(context)?.localeName ?? ''),
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 2),
                  lastDate: DateTime(DateTime.now().year + 2));
              if (date != null) {
                currentDate = date;
                context.read<DateBloc>().add(DateEvent(date: date));
                context.read<TaskBloc>().add(TaskEvent(
                    requestEvent: CrudEventStatus.FETCH,
                    date: date,
                    categoryId: widget.categoryId));
              }
            },
            child: const Icon(
              Icons.calendar_month_outlined,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createListener(Widget child) {
    return Listener(
        child: child,
        onPointerMove: (PointerMoveEvent event) {
          if (!_isDragging) {
            return;
          }
          RenderBox render =
              _listViewKey.currentContext?.findRenderObject() as RenderBox;
          Offset position = render.localToGlobal(Offset.zero);
          double leftX = position.dx;
          double rightX = leftX + render.size.width;
          const moveDistance = 3;
          const detectedRange = 100;
          if ((AppLocalizations.of(context)?.localeName ?? '') == 'ar') {
            if (event.position.dx < leftX + detectedRange) {
              _scroller.jumpTo(_scroller.offset + moveDistance);
            }
            if (event.position.dx > rightX - detectedRange) {
              var to = _scroller.offset - moveDistance;
              to = (to < 0) ? 0 : to;
              _scroller.jumpTo(to);
            }
          } else {
            if (event.position.dx < leftX + detectedRange) {
              var to = _scroller.offset - moveDistance;
              to = (to < 0) ? 0 : to;
              _scroller.jumpTo(to);
            }
            if (event.position.dx > rightX - detectedRange) {
              _scroller.jumpTo(_scroller.offset + moveDistance);
            }
          }
        });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _scroller.dispose();
    super.dispose();
  }
}

class MyColumn extends StatefulWidget {
  ThemeColor themeColor;
  LinearGradient gradient;
  String title;
  List<Task> list;
  TaskStatus status;

  MyColumn({
    required this.themeColor,
    required this.gradient,
    required this.list,
    required this.title,
    required this.status,
  });
  @override
  State<MyColumn> createState() => _MyColumnState();
}

bool isRecived = false;

class _MyColumnState extends State<MyColumn> {
  Key _columnKey = GlobalKey();

  Configuration get configuration => GetIt.I<Configuration>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var columnWith = width * .95;
    if (width > 600) {
      columnWith = width * .4;
    }
    return DragTarget<DragData>(onAccept: (data) {
      _acceptDraggedItem(data);
    }, builder: (
      BuildContext context,
      List<dynamic> accepted,
      List<dynamic> rejected,
    ) {
      return Container(
        // height: height * .5,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: widget.gradient),
              width: columnWith,
              height: 50,
              child: Text(widget.title,
                  style: TextStyle(
                      fontFamily: configuration.currentFont,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: widget.themeColor.fgColor)),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(),
                width: columnWith,
                height: double.infinity,
                child: ListView.builder(
                    itemCount: widget.list.length,
                    itemBuilder: (context, index) {
                      final task = widget.list[index];
                      return Draggable<DragData>(
                        data: DragData(originColumnKey: _columnKey, data: task),
                        onDragCompleted: () {
                          if (isRecived) {
                            isRecived = false;
                            // SchedulerBinding.instance?
                            //     .addPostFrameCallback((_) {

                          }
                        },
                        onDragStarted: () => _isDragging = true,
                        onDragEnd: (details) {
                          _isDragging = false;
                        },
                        onDraggableCanceled: (velocity, offset) {
                          _isDragging = false;
                        },
                        childWhenDragging: Opacity(
                          opacity: .2,
                          child: MyCard(
                            textColor: widget.themeColor.fgColor,
                            color: widget.themeColor.primaryColor,
                            task: task,
                          ),
                        ),
                        child: MyCard(
                          textColor: widget.themeColor.fgColor,
                          color: widget.themeColor.drowerBgClor,
                          task: task,
                        ),
                        feedback: MyCard(
                          textColor: Colors.white,
                          color: widget.themeColor.primaryColor,
                          task: task,
                          requestWidth: columnWith,
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _acceptDraggedItem(DragData dragData) {
    if (dragData.originColumnKey != _columnKey) {
      isRecived = true;
      var _task = dragData.data;
      _task.status = widget.status;
      context
          .read<CrudTaskBloc>()
          .add(CrudTaskEvent(requestEvent: CrudEventStatus.EDIT, task: _task));
      Future.delayed(const Duration(microseconds: 300)).then((value) {
        context
            .read<TodayBloc>()
            .add(TodayEvent(requestEvent: CrudEventStatus.FETCH));
        context
            .read<CategoryBloc>()
            .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));
        context
            .read<CrudTaskBloc>()
            .add(CrudTaskEvent(requestEvent: CrudEventStatus.RESET));
      });
    }
  }
}

class MyCard extends StatelessWidget {
  Color color;
  Color textColor;
  Task task;
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  double? requestWidth;
  Configuration get configuration => GetIt.I<Configuration>();

  MyCard(
      {required this.textColor,
      required this.color,
      required this.task,
      this.requestWidth});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: StatefulBuilder(builder: (context, setInnerState) {
          return GestureDetector(
              onTap: () {
                _cardInnerState = setInnerState;
                if (_taskMenuInnerState != null) {
                  _taskMenuInnerState!(() {
                    GTask = task;
                    isTaskMenuOpen = true;
                    _controller1.forward();
                  });
                }

                _cardInnerState!(() {
                  cardColor = themeColor.drowerLightBgClor;
                });
              },
              child: Card(
                color: cardColor,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 55,
                    width: requestWidth ?? width,
                    child: ListTile(
                      horizontalTitleGap: 0,
                      leading: getIcon(context),
                      title: Row(
                        children: [
                          Text(task.title ?? '',
                              style: TextStyle(
                                  fontFamily: configuration.currentFont,
                                  fontSize: 19,
                                  color: textColor)),
                          const Spacer(),
                          (task.status == TaskStatus.UNDONE ||
                                  task.status == TaskStatus.DONE)
                              ? Container()
                              : IconButton(
                                  icon: const Icon(
                                    Icons.edit_note,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, route.addTaskPage, arguments: {
                                      'categoryId': task.categoryId,
                                      'task': task,
                                      'rotate': true
                                    });
                                  },
                                ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () {
                          context.read<TodayBloc>().add(
                              TodayEvent(requestEvent: CrudEventStatus.FETCH));
                          context.read<CategoryBloc>().add(CategoryEvent(
                              requestEvent: CrudEventStatus.FETCH));
                          context.read<CrudTaskBloc>().add(CrudTaskEvent(
                              requestEvent: CrudEventStatus.DELETE,
                              taskId: task.id));
                          context.read<ReminderBloc>().add(ReminderEvent(
                              requestEvent: ReminderEventStatus.TODAY));
                          context.read<TaskBloc>().add(TaskEvent(
                              requestEvent: CrudEventStatus.FETCH,
                              date: currentDate,
                              categoryId: task.categoryId ?? ''));
                          context.read<CrudTaskBloc>().add(CrudTaskEvent(
                              requestEvent: CrudEventStatus.RESET));
                        },
                      ),
                    )),
              ));
        }));
  }

  Widget getIcon(BuildContext context) {
    switch (task.status) {
      case TaskStatus.DONE:
        return const Icon(
          Icons.done_all,
          color: Color.fromARGB(255, 0, 255, 8),
          size: 30,
        );
      case TaskStatus.UNDONE:
        return const Icon(
          Icons.close,
          color: Color.fromARGB(255, 255, 0, 0),
          size: 30,
        );
      default:
        return IconButton(
          icon: Icon(
            Icons.check,
            color: textColor,
            size: 30,
          ),
          onPressed: () {
            task.status = TaskStatus.DONE;
            context.read<CrudTaskBloc>().add(
                CrudTaskEvent(requestEvent: CrudEventStatus.EDIT, task: task));
            context
                .read<CategoryBloc>()
                .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));
            context
                .read<TodayBloc>()
                .add(TodayEvent(requestEvent: CrudEventStatus.FETCH));
            context.read<TaskBloc>().add(TaskEvent(
                requestEvent: CrudEventStatus.FETCH,
                date: currentDate,
                categoryId: task.categoryId ?? ''));
            context
                .read<CrudTaskBloc>()
                .add(CrudTaskEvent(requestEvent: CrudEventStatus.RESET));
          },
        );
    }
  }
}
