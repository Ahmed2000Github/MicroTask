import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/date/date_bloc.dart';
import 'package:microtask/blocs/reminder/reminder_bloc.dart';
import 'package:microtask/blocs/reminder/reminder_event.dart';
import 'package:microtask/blocs/task/task_bloc.dart';
import 'package:microtask/blocs/task/task_event.dart';
import 'package:microtask/blocs/task/task_state.dart';
import 'package:microtask/blocs/today/today_bloc.dart';
import 'package:microtask/blocs/today/today_event.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/models/drag_data.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/services/notification_service.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/no_data_found_widget.dart';

DateTime currentDate = DateTime.now();

class TaskPage extends StatefulWidget {
  String categoryId;
  TaskPage({required this.categoryId});
  @override
  State<TaskPage> createState() => _TaskPageState();
}

bool _isDragging = false;

class _TaskPageState extends State<TaskPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  NotificationServices get notificationServices =>
      GetIt.I<NotificationServices>();

  List<DateTime> list = [];
  bool headerVisibility = true;
  final ScrollController _scroller = ScrollController();
  final _listViewKey = GlobalKey();
  genrateList(DateTime date) {
    var startFrom = date.subtract(Duration(days: date.weekday - 1));
    list = List.generate(7, (i) => startFrom.add(Duration(days: i)));
  }

  @override
  void initState() {
    super.initState();

    genrateList(DateTime.now());
    context.read<TaskBloc>().add(TaskEvent(
        requestEvent: CrudEventStatus.FETCH,
        date: currentDate,
        categoryId: widget.categoryId));
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
            height: 14,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                Spacer(),
                Text('Tasks',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: themeColor.fgColor)),
                Spacer(),
                FloatingActionButton(
                  heroTag: 'today',
                  tooltip: 'To day',
                  backgroundColor: themeColor.secondaryColor,
                  onPressed: () {
                    currentDate = DateTime.now();
                    context.read<DateBloc>().add(DateEvent(
                        date: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day)));
                    context.read<TaskBloc>().add(TaskEvent(
                        requestEvent: CrudEventStatus.FETCH,
                        date: DateTime.now(),
                        categoryId: widget.categoryId));
                  },
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                FloatingActionButton(
                  heroTag: 'date',
                  tooltip: 'Choose date',
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                        context: context,
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
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              Visibility(
                  visible: headerVisibility,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 5, 10),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              '${DateFormat("dd MMMM").format(DateTime.now())}',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: themeColor.fgColor)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: Container(
                          child: Row(
                            children: [
                              Spacer(),
                              Text(
                                  '${DateFormat("EEEE").format(DateTime.now())}',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                      color: themeColor.secondaryColor)),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, route.addTaskPage, arguments: {
                                    'categoryId': widget.categoryId
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('ADD',
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: height * .2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<DateBloc, DateState>(
                              builder: (context, state) {
                            genrateList(state.date);
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 7,
                              itemBuilder: (context, index) {
                                final date = DateTime(list[index].year,
                                    list[index].month, list[index].day);
                                Color currentColor = themeColor.primaryColor;
                                if (date == state.date)
                                  currentColor = themeColor.secondaryColor;
                                return Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        currentDate = date;
                                        context
                                            .read<DateBloc>()
                                            .add(DateEvent(date: date));
                                        context.read<TaskBloc>().add(TaskEvent(
                                            requestEvent: CrudEventStatus.FETCH,
                                            date: date,
                                            categoryId: widget.categoryId));
                                      },
                                      child: Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: currentColor,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  '${DateFormat("MMM").format(list[index])}',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: currentColor)),
                                              Text(
                                                  '${DateFormat("dd").format(list[index])}',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: currentColor)),
                                              Text(
                                                  '${DateFormat("EEE").format(list[index])}',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: currentColor)),
                                            ]),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
                child: Container(
                  child: Row(
                    children: [
                      Text('Tasks manager',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: themeColor.fgColor)),
                      Spacer(),
                      Visibility(
                        visible: !headerVisibility,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, route.addTaskPage,
                                arguments: {'categoryId': widget.categoryId});
                          },
                          icon: Icon(Icons.add,
                              color: themeColor.primaryColor, size: 35),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<TaskBloc>().add(TaskEvent(
                              requestEvent: CrudEventStatus.FETCH,
                              date: currentDate,
                              categoryId: widget.categoryId));
                        },
                        icon: Icon(Icons.refresh_outlined,
                            color: themeColor.primaryColor, size: 35),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            headerVisibility = !headerVisibility;
                          });
                        },
                        icon: Icon(
                            headerVisibility
                                ? Icons.keyboard_double_arrow_up_outlined
                                : Icons.keyboard_double_arrow_down,
                            color: headerVisibility
                                ? themeColor.primaryColor
                                : themeColor.errorColor,
                            size: 35),
                      )
                    ],
                  ),
                ),
              ),
              BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
                switch (state.requestState) {
                  case StateStatus.LOADING:
                    return CustomLoadingProgress(
                        color: themeColor.primaryColor, height: height * .8);
                  case StateStatus.ERROR:
                    return NoDataFoundWidget(
                      text: state.errormessage ?? '',
                    );
                  case StateStatus.LOADED:
                    return Container(
                      height: height * .8,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _createListener(
                            ListView(
                              key: _listViewKey,
                              controller: _scroller,
                              scrollDirection: Axis.horizontal,
                              children: [
                                MyColumn(
                                    themeColor: themeColor,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 128, 0),
                                        Color.fromARGB(255, 255, 252, 59),
                                      ],
                                    ),
                                    title: "To do",
                                    list: state.todoTasks!),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyColumn(
                                    themeColor: themeColor,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 252, 59),
                                        Color.fromARGB(255, 111, 255, 0),
                                      ],
                                    ),
                                    title: "Doing",
                                    list: state.doingTasks!),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyColumn(
                                    themeColor: themeColor,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 111, 255, 0),
                                        Color.fromARGB(255, 59, 154, 255),
                                      ],
                                    ),
                                    title: "Done",
                                    list: state.doneTasks!),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyColumn(
                                    themeColor: themeColor,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 59, 154, 255),
                                        Color.fromARGB(255, 255, 0, 115),
                                      ],
                                    ),
                                    title: "UnDone",
                                    list: state.undoneTasks!),
                              ],
                            ),
                          )),
                    );

                  default:
                    return Container();
                }
              })
            ],
          ))
        ],
      ),
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
          double topX = position.dx;
          double bottomX = topX + render.size.width;
          const moveDistance = 3;
          const detectedRange = 100;

          if (event.position.dx < topX + detectedRange) {
            var to = _scroller.offset - moveDistance;
            to = (to < 0) ? 0 : to;
            _scroller.jumpTo(to);
          }
          if (event.position.dx > bottomX - detectedRange) {
            _scroller.jumpTo(_scroller.offset + moveDistance);
          }
        });
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }
}

class MyColumn extends StatefulWidget {
  ThemeColor themeColor;
  LinearGradient gradient;
  String title;
  List<Task> list;
  TaskStatus? status;

  MyColumn({
    required this.themeColor,
    required this.gradient,
    required this.list,
    required this.title,
  }) {
    status = EnumToString.fromString(
        TaskStatus.values, title.replaceAll(' ', '').toUpperCase());
  }
  @override
  State<MyColumn> createState() => _MyColumnState();
}

bool isRecived = false;

class _MyColumnState extends State<MyColumn> {
  Key _columnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return DragTarget<DragData>(onAccept: (data) {
      _acceptDraggedItem(data);
    }, builder: (
      BuildContext context,
      List<dynamic> accepted,
      List<dynamic> rejected,
    ) {
      return Container(
        height: height * .5,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: widget.gradient),
              width: width * .95,
              height: 60,
              child: Text(widget.title,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: widget.themeColor.fgColor)),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(),
                width: width * .95,
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
                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              context.read<TaskBloc>().add(TaskEvent(
                                  requestEvent: CrudEventStatus.FETCH,
                                  date: currentDate,
                                  categoryId: task.categoryId ?? ''));
                              context.read<TodayBloc>().add(TodayEvent(
                                  requestEvent: CrudEventStatus.FETCH));
                              context.read<CategoryBloc>().add(CategoryEvent(
                                  requestEvent: CrudEventStatus.FETCH));
                              context.read<CrudTaskBloc>().add(CrudTaskEvent(
                                  requestEvent: CrudEventStatus.RESET));
                            });
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
    }
  }
}

class MyCard extends StatelessWidget {
  Color color;
  Color textColor;
  Task task;

  MyCard({required this.textColor, required this.color, required this.task});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Card(
        color: color,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            height: 70,
            width: width,
            child: ListTile(
              leading: getIcon(context),
              title: Row(
                children: [
                  Text(task.title ?? '',
                      style: TextStyle(fontSize: 20, color: textColor)),
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
                            Navigator.pushNamed(context, route.addTaskPage,
                                arguments: {
                                  'categoryId': task.categoryId,
                                  'task': task
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
                  context
                      .read<TodayBloc>()
                      .add(TodayEvent(requestEvent: CrudEventStatus.FETCH));
                  context
                      .read<CategoryBloc>()
                      .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));
                  context.read<CrudTaskBloc>().add(CrudTaskEvent(
                      requestEvent: CrudEventStatus.DELETE, taskId: task.id));
                  context.read<ReminderBloc>().add(
                      ReminderEvent(requestEvent: ReminderEventStatus.TODAY));
                  context.read<TaskBloc>().add(TaskEvent(
                      requestEvent: CrudEventStatus.FETCH,
                      date: currentDate,
                      categoryId: task.categoryId ?? ''));
                  context
                      .read<CrudTaskBloc>()
                      .add(CrudTaskEvent(requestEvent: CrudEventStatus.RESET));
                },
              ),
            )),
      ),
    );
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
