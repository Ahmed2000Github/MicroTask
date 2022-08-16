import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/category/category_state.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/home/home_bloc.dart';
import 'package:microtask/blocs/today/today_bloc.dart';
import 'package:microtask/blocs/today/today_event.dart';
import 'package:microtask/blocs/today/today_state.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/custum_progress.dart';
import 'package:microtask/widgets/no_data_found_widget.dart';

class HomePage extends StatefulWidget {
  User? user;

  HomePage() {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

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
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 40,
                  color: themeColor.fgColor,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: 40,
                  color: themeColor.secondaryColor,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              SizedBox(
                width: width * .01,
              ),
              GestureDetector(
                onTap: () {
                  context.read<HomeBloc>().add(HomeEvent.PROFILE);
                },
                child: CircleAvatar(
                  backgroundImage:
                      const AssetImage("assets/images/picture.jpg"),
                  radius: 18,
                  backgroundColor: themeColor.primaryColor,
                  child: ClipOval(
                      child: !(widget.user?.photoURL ?? "").isEmpty
                          ? Image.network(
                              (widget.user?.photoURL ?? ""),
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "assets/images/picture.jpg",
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                            )),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Welcome, ${widget.user?.displayName}",
              style: TextStyle(
                fontSize: 30,
                color: themeColor.fgColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "${DateFormat('EEEE d MMMM').format(today)}",
              style: TextStyle(
                fontSize: 20,
                color: themeColor.primaryLightColor,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${'categories'.toUpperCase()}",
                    style: TextStyle(
                      fontSize: 30,
                      color: themeColor.fgColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                  switch (state.requestState) {
                    case StateStatus.LOADING:
                      return CustomLoadingProgress(
                          color: themeColor.primaryColor, height: height * .4);
                    case StateStatus.LOADED:
                      if (state.categories?.isEmpty as bool) {
                        return Container(
                          constraints: const BoxConstraints(
                            minHeight: 270,
                            maxHeight: 270,
                          ),
                          height: height * .4,
                          child: NoDataFoundWidget(
                            text: 'Not category found',
                            action: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, route.addCategoryPage);
                              },
                              child: const Text(
                                'Add Category',
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container(
                        constraints: const BoxConstraints(
                          minHeight: 270,
                          maxHeight: 270,
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories?.length,
                          itemBuilder: (context, index) {
                            var category = state.categories?[index];
                            double percent = (category?.numberTaskDone ?? 0) /
                                (category?.numberTask ?? 0);
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, route.taskPage,
                                    arguments: category?.id);
                              },
                              child: Container(
                                width: width * .5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: themeColor.primaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${category?.name?.toUpperCase()}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 23),
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          CustomProgress(
                                              percent: percent,
                                              radius: 120,
                                              lineWidth: 13,
                                              textSize: 23,
                                              themeColor: themeColor),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Total: ${category?.numberTask} Tasks",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
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
              BlocBuilder<TodayBloc, TodayState>(builder: (context, state) {
                switch (state.requestState) {
                  case StateStatus.LOADING:
                    return CustomLoadingProgress(
                        color: themeColor.primaryColor, height: height * .4);
                  case StateStatus.LOADED:
                    if (state.todayTasks?.isEmpty as bool) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 5, 5),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    "${'today\'s tasks'.toUpperCase()}",
                                    style: TextStyle(
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
                            height: height * .4,
                            child: NoDataFoundWidget(
                              text: 'No task to do today',
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 5, 5),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  "${'today\'s tasks'.toUpperCase()}",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: themeColor.fgColor,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${'${state.todayTasks?.length} Tasks'.toUpperCase()}",
                                  style: TextStyle(
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
                                        selectedColor: themeColor.primaryColor,
                                        leading: IconButton(
                                          icon: task?.status == TaskStatus.DONE
                                              ? Icon(
                                                  Icons.check_circle,
                                                  size: 30,
                                                  color:
                                                      themeColor.secondaryColor,
                                                )
                                              : Icon(
                                                  Icons.circle_outlined,
                                                  size: 30,
                                                  color:
                                                      themeColor.secondaryColor,
                                                ),
                                          onPressed: () {},
                                        ),
                                        trailing: task?.status ==
                                                TaskStatus.DONE
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  size: 30,
                                                  color:
                                                      themeColor.secondaryColor,
                                                ),
                                                onPressed: () {
                                                  var _task = task;
                                                  _task?.showInToday = false;
                                                  context
                                                      .read<CrudTaskBloc>()
                                                      .add(CrudTaskEvent(
                                                          requestEvent:
                                                              CrudEventStatus
                                                                  .EDIT,
                                                          task: _task));
                                                  context.read<TodayBloc>().add(
                                                      TodayEvent(
                                                          requestEvent:
                                                              CrudEventStatus
                                                                  .FETCH));
                                                  context
                                                      .read<CrudTaskBloc>()
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
                                              style: const TextStyle(
                                                fontSize: 25,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              EnumToString.convertToString(
                                                      task?.status)
                                                  .toLowerCase(),
                                              style: TextStyle(
                                                color:
                                                    themeColor.secondaryColor,
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
            ],
          ),
        )
      ],
    );
  }
}
