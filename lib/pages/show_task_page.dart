import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_cubit.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/category/category_state.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/note/note_crud_bloc.dart';
import 'package:microtask/blocs/note/note_cubit.dart';
import 'package:microtask/blocs/note/note_event.dart';
import 'package:microtask/blocs/note/note_state.dart';
import 'package:microtask/blocs/task/task_cubit.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/models/note_model.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/services/enum_translate_services.dart';
import 'package:microtask/widgets/custom_appbar_widget.dart';
import 'package:microtask/widgets/no_data_found_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowTaskPage extends StatefulWidget {
  bool? rotate;
  String? taskId;
  Map<String, dynamic> data;
  ShowTaskPage({required this.data, this.rotate}) {
    rotate = data['rotate'];
    taskId = data['taskId'];
  }
  @override
  State<ShowTaskPage> createState() => _ShowTaskPageState();
}

class _ShowTaskPageState extends State<ShowTaskPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  Configuration get configuration => GetIt.I<Configuration>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();

  // final GlobalKey _first = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().changeState(widget.taskId!);
    context.read<CategoryCubit>().changeState();
    context.read<NoteCubit>().changeState();

    // if (showCaseConfig.isLunched(route.notesPage)) {
    //   WidgetsBinding.instance?.addPostFrameCallback(
    //     (_) => Future.delayed(const Duration(seconds: 1)).then(
    //         (value) => ShowCaseWidget.of(context).startShowCase([_first])),
    //   );
    // }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeColor.bgColor,
      body: BlocListener<CrudNoteBloc, NoteState>(
        listener: (context, state) {
          if (state.requestState == StateStatus.LOADED) {
            context.read<NoteCubit>().changeState();
          }
        },
        child: Column(children: [
          CustomAppBar(title: ''),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 8, 0),
            child: Row(
              children: [
                Container(
                  width: width * .5,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      AppLocalizations.of(context)?.taskDetails ?? '',
                      style: TextStyle(
                        fontFamily: configuration.currentFont,
                        color: themeColor.fgColor,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Lottie.asset(
                  'assets/lotties/task.json',
                  width: width * .35,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskCubit, Task>(
              builder: (context, task) {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ListView(
                      children: [
                        _nameTask(task.title!),
                        const SizedBox(
                          height: 10,
                        ),
                        _descriptionTask(task.description!),
                        const SizedBox(
                          height: 10,
                        ),
                        _categoryTask(task),
                        const SizedBox(
                          height: 10,
                        ),
                        _startDateTask(task),
                        const SizedBox(
                          height: 10,
                        ),
                        _endDateTask(task),
                        const SizedBox(
                          height: 10,
                        ),
                        _reminderTask(task),
                        const SizedBox(
                          height: 10,
                        ),
                        _statusTask(task),
                        const SizedBox(
                          height: 10,
                        ),
                        _hasNoteTask(task),
                      ],
                    ));
              },
            ),
          )
        ]),
      ),
    );
  }

  Widget _nameTask(String name) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Card(
          color: themeColor.drowerBgClor,
          child: ListTile(
            leading: Text(
              AppLocalizations.of(context)?.taskName ?? '',
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.fgColor,
                fontSize: 18,
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.secondaryColor,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _descriptionTask(String description) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Card(
          color: themeColor.drowerBgClor,
          child: Column(
            children: [
              ListTile(
                leading: Text(
                  (AppLocalizations.of(context)?.taskDescription ?? ''),
                  style: TextStyle(
                    fontFamily: configuration.currentFont,
                    color: themeColor.fgColor,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 130,
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    style: TextStyle(
                      fontFamily: configuration.currentFont,
                      color: themeColor.secondaryColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _categoryTask(Task task) {
    bool isEditMode = false;
    List<Category> list = context.read<CategoryCubit>().state;
    print("ts     ${task.categoryId}");
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Card(
          color: themeColor.drowerBgClor,
          child: ListTile(
            leading: Text(
              AppLocalizations.of(context)?.taskCategory ?? '',
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.fgColor,
                fontSize: 18,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.edit,
                color:
                    isEditMode ? themeColor.secondaryColor : themeColor.fgColor,
              ),
              onPressed: () {
                setInnerState(() {
                  isEditMode = !isEditMode;
                });
              },
            ),
            title: isEditMode
                ? DropdownButtonFormField<Category>(
                    value: list
                        .where((element) => element.id == task.categoryId)
                        .first,
                    dropdownColor: themeColor.bgColor,
                    items: _getDropMenuItems(list),
                    onChanged: (value) {
                      task.categoryId = value?.id;
                      context.read<CrudTaskBloc>().add(CrudTaskEvent(
                          requestEvent: CrudEventStatus.EDIT, task: task));
                      context.read<TaskCubit>().changeState(widget.taskId!);
                    },
                    style: TextStyle(
                        fontFamily: configuration.currentFont,
                        color: themeColor.fgColor,
                        fontSize: 20),
                  )
                : Text(
                    list
                        .where((element) => element.id == task.categoryId)
                        .first
                        .name!,
                    style: TextStyle(
                      fontFamily: configuration.currentFont,
                      color: themeColor.secondaryColor,
                      fontSize: 18,
                    ),
                  ),
          ),
        );
      },
    );
  }

  List<DropdownMenuItem<Category>> _getDropMenuItems(List<Category> list) {
    return list
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item.name!,
                  style: TextStyle(
                      fontFamily: configuration.currentFont,
                      fontSize: 22,
                      color: themeColor.fgColor)),
            ))
        .toList();
  }

  Widget _startDateTask(Task task) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Card(
          color: themeColor.drowerBgClor,
          child: ListTile(
            leading: Text(
              AppLocalizations.of(context)?.taskStartDate ?? '',
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.fgColor,
                fontSize: 18,
              ),
            ),
            title: Text(
              DateFormat("dd - MM - yyyy    HH:mm:ss")
                  .format(task.startDateTime!),
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.secondaryColor,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _endDateTask(Task task) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Card(
          color: themeColor.drowerBgClor,
          child: ListTile(
            leading: Text(
              AppLocalizations.of(context)?.taskEndDate ?? '',
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.fgColor,
                fontSize: 18,
              ),
            ),
            title: Text(
              DateFormat("dd - MM - yyyy    HH:mm:ss")
                  .format(task.endDateTime!),
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.secondaryColor,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _statusTask(Task task) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Card(
          color: themeColor.drowerBgClor,
          child: ListTile(
            leading: Text(
              AppLocalizations.of(context)?.taskStatus ?? '',
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.fgColor,
                fontSize: 18,
              ),
            ),
            title: Text(
              EnumTranslateServices.translateTaskStatus(context, task.status!),
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.secondaryColor,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _reminderTask(Task task) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Card(
          color: themeColor.drowerBgClor,
          child: ListTile(
            leading: Text(
              AppLocalizations.of(context)?.taskReminder ?? '',
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.fgColor,
                fontSize: 18,
              ),
            ),
            title: Text(
              !task.reminder!
                  ? (AppLocalizations.of(context)?.desactivate ?? '')
                  : AppLocalizations.of(context)?.activate ?? '',
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.secondaryColor,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _hasNoteTask(Task task) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Card(
          color: themeColor.drowerBgClor,
          child: ListTile(
            leading: Text(
              AppLocalizations.of(context)?.taskHasNote ?? '',
              style: TextStyle(
                fontFamily: configuration.currentFont,
                color: themeColor.fgColor,
                fontSize: 18,
              ),
            ),
            title: task.noteId == null
                ? Text(
                    AppLocalizations.of(context)?.taskNoNote ?? '',
                    style: TextStyle(
                      fontFamily: configuration.currentFont,
                      color: themeColor.secondaryColor,
                      fontSize: 18,
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      if (widget.rotate != null) {
                        Navigator.pushNamed(context, route.notePage,
                            arguments: {'noteId': task.noteId});
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      context
                          .read<NoteCubit>()
                          .state
                          .where((element) => element.id == task.noteId)
                          .first
                          .title!,
                      style: TextStyle(
                        fontFamily: configuration.currentFont,
                        color: themeColor.primaryLightColor,
                        fontSize: 18,
                      ),
                    )),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.rotate != null) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }
}
