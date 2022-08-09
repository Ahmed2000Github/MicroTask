import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:microtask/blocs/date/date_bloc.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/models/drag_data.dart';

List<String> doingList = ['Task 1', 'Task 2'];
List<String> todoList = ['Task ', 'Task ', 'task 3'];

class TaskPage extends StatefulWidget {
  @override
  State<TaskPage> createState() => _TaskPageState();
}

bool _isDragging = false;

class _TaskPageState extends State<TaskPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  List<DateTime> list = [];
  final ScrollController _scroller = ScrollController();
  final _listViewKey = GlobalKey();
  genrateList(DateTime date) {
    var startFrom = date.subtract(Duration(days: date.weekday));
    list = List.generate(7, (i) => startFrom.add(Duration(days: i)));
  }

  @override
  void initState() {
    super.initState();
    genrateList(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeColor.bgColor,
      body: ListView(
        children: [
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
                FloatingActionButton(
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 2),
                        lastDate: DateTime(DateTime.now().year + 2));
                    if (date != null) {
                      context.read<DateBloc>().add(DateEvent(date: date));
                    }
                  },
                  child: const Icon(
                    Icons.calendar_month_outlined,
                    size: 30,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
            child: Container(
              child: Text('${DateFormat("dd MMMM").format(DateTime.now())}',
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
                  Text('${DateFormat("EEEE").format(DateTime.now())}',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: themeColor.secondaryColor)),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {},
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
              child:
                  BlocBuilder<DateBloc, DateState>(builder: (context, state) {
                genrateList(state.date);
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final currentDate = DateTime(
                        list[index].year, list[index].month, list[index].day);
                    Color currentColor = themeColor.primaryColor;
                    if (currentDate == state.date)
                      currentColor = themeColor.secondaryColor;
                    return Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<DateBloc>()
                                .add(DateEvent(date: currentDate));
                          },
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: currentColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      '${DateFormat("MMM").format(list[index])}',
                                      style: TextStyle(
                                          fontSize: 25, color: currentColor)),
                                  Text(
                                      '${DateFormat("dd").format(list[index])}',
                                      style: TextStyle(
                                          fontSize: 25, color: currentColor)),
                                  Text(
                                      '${DateFormat("EEE").format(list[index])}',
                                      style: TextStyle(
                                          fontSize: 25, color: currentColor)),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
            child: Container(
              child: Text('Tasks manager',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: themeColor.fgColor)),
            ),
          ),
          BlocBuilder<DateBloc, DateState>(builder: (context, state) {
            return Container(
              height: height * .5,
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
                            date: state.date),
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
                            date: state.date),
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
                            date: state.date),
                      ],
                    ),
                  )),
            );
          })
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
  DateTime date;
  late List<String> list;

  MyColumn(
      {required this.themeColor,
      required this.gradient,
      required this.title,
      required this.date}) {
    list = title == 'To do' ? todoList : doingList;
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
                      final item = widget.list[index];
                      return Draggable<DragData>(
                        data: DragData(originColumnKey: _columnKey, data: item),
                        onDragCompleted: () {
                          if (isRecived) {
                            setState(() {
                              isRecived = false;
                              widget.list.remove(item);
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
                              title: item,
                              date: widget.date),
                        ),
                        child: MyCard(
                            textColor: widget.themeColor.fgColor,
                            color: widget.themeColor.drowerBgClor,
                            title: item,
                            date: widget.date),
                        feedback: MyCard(
                            textColor: Colors.white,
                            color: widget.themeColor.primaryColor,
                            title: item,
                            date: widget.date),
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
      setState(() {
        isRecived = true;
        widget.list.add(dragData.data);
      });
    }
  }
}

class MyCard extends StatelessWidget {
  Color color;
  Color textColor;
  String title;
  DateTime date;

  MyCard(
      {required this.textColor,
      required this.color,
      required this.title,
      required this.date});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        height: 70,
        width: width,
        child: Row(
          children: [
            // Icon(
            //   Icons.check,
            //   color: textColor,
            //   size: 30,
            // ),
            Spacer(),
            Text(title, style: TextStyle(fontSize: 28, color: textColor)),
            Spacer(),
            //  IconButton(
            //     icon: Icon(
            //       Icons.delete_outline,
            //       color: Colors.red,
            //       size: 30,
            //     ),
            //     onPressed: () {},
            //   ),
          ],
        ),
      ),
    );
  }
}
