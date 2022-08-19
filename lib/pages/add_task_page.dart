import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/crud_task/crud_task_state.dart';
import 'package:microtask/blocs/reminder/reminder_bloc.dart';
import 'package:microtask/blocs/reminder/reminder_event.dart';
import 'package:microtask/blocs/task/task_bloc.dart';
import 'package:microtask/blocs/task/task_event.dart';
import 'package:microtask/blocs/today/today_bloc.dart';
import 'package:microtask/blocs/today/today_event.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/custom_snakbar_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class AddTaskPage extends StatefulWidget {
  Task? task;
  String? categoryId;
  Map<String, dynamic> data;

  AddTaskPage({Key? key, required this.data}) : super(key: key) {
    task = data['task'];
    categoryId = data['categoryId'];
  }

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _subFormKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _subFormKey2 = GlobalKey<FormState>();

  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  RepeatType? repeatType;
  TextEditingController nameController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
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
  ];
  bool reminder = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.task?.title ?? '';
    descriptionController.text = widget.task?.description ?? '';
    startDateController.text = DateFormat("yyyy - MM - dd")
        .format(widget.task?.startDateTime ?? DateTime.now());
    startTimeController.text = DateFormat("HH:mm")
        .format(widget.task?.startDateTime ?? DateTime.now());
    endDateController.text = DateFormat("yyyy - MM - dd")
        .format(widget.task?.endDateTime ?? DateTime.now());
    endTimeController.text = DateFormat("HH:mm").format(
        widget.task?.endDateTime ??
            DateTime.now().add(const Duration(minutes: 10)));
    context
        .read<CrudTaskBloc>()
        .add(CrudTaskEvent(requestEvent: CrudEventStatus.RESET));

    if (widget.task != null) {
      repeatType = widget.task?.repeatType;
      reminder = widget.task?.reminder as bool;
    }
    if (showCaseConfig.isLunched(route.addTaskPage)) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(Duration(seconds: 1))
            .then((value) => ShowCaseWidget.of(context).startShowCase(_list)),
      );
    }
  }

  //  {
  Widget _titleField() {
    return TextFormField(
      style: TextStyle(color: themeColor.fgColor, fontSize: 20),
      controller: nameController,
      decoration: InputDecoration(
          labelText: 'Enter the name',
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: themeColor.secondaryColor)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: themeColor.primaryColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: themeColor.primaryColor, width: 2.0),
          ),
          labelStyle: TextStyle(color: themeColor.fgColor.withOpacity(.6)),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintStyle: TextStyle(
              color: themeColor.fgColor.withOpacity(.5), fontSize: 20),
          hintText: "Name ... ",
          // fillColor: themeColor.inputbgColor,
          filled: true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value?.isEmpty as bool) {
          return 'The name should not be empty';
        }
        if (value?.length as int > 12) {
          return 'The name should not contains more than 12 caracters';
        }
      },
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      minLines: 1,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      style: TextStyle(color: themeColor.fgColor, fontSize: 20),
      controller: descriptionController,
      decoration: InputDecoration(
          labelText: 'Enter the description',
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: themeColor.secondaryColor)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: themeColor.secondaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: themeColor.primaryColor, width: 2.0),
          ),
          labelStyle: TextStyle(color: themeColor.fgColor.withOpacity(.6)),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintStyle: TextStyle(
              color: themeColor.fgColor.withOpacity(.5), fontSize: 20),
          hintText: "description ...",
          // fillColor: themeColor.inputbgColor,
          filled: true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value?.isEmpty as bool) {
          return 'The description should not be empty';
        }
      },
    );
  }

  Widget _dateField(TextEditingController dateController,
      TextEditingController timeController, String type) {
    return Form(
      key: type == 'end' ? _subFormKey2 : _subFormKey1,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: TextFormField(
              keyboardType: TextInputType.datetime,
              style: TextStyle(color: themeColor.fgColor, fontSize: 20),
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: themeColor.fgColor,
                    ),
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: getDateTime(
                              dateController.text, timeController.text),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 2));
                      if (date != null) {
                        dateController.text =
                            DateFormat("yyyy - MM - dd").format(date);
                        _subFormKey2.currentState!.validate();
                        if (type == 'start') {
                          setState(() {});
                        }
                      }
                    },
                  ),
                  labelText: 'Enter the $type date',
                  border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: themeColor.secondaryColor)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: themeColor.secondaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide:
                        BorderSide(color: themeColor.primaryColor, width: 2.0),
                  ),
                  labelStyle:
                      TextStyle(color: themeColor.fgColor.withOpacity(.6)),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  hintStyle: TextStyle(
                      color: themeColor.fgColor.withOpacity(.5), fontSize: 20),
                  hintText: "Start date ...",
                  filled: true),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value?.isEmpty as bool) {
                  return 'The date should not be empty';
                }
                final duration = getDateTime(
                        endDateController.text, endTimeController.text)
                    .difference(getDateTime(
                        startDateController.text, startTimeController.text));
                if (duration.compareTo(const Duration(minutes: 10)) < 0 &&
                    type == 'end') {
                  return 'The and date should not less\n than start date by 10 minute';
                }
              },
            ),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * .35,
            child: TextFormField(
              keyboardType: TextInputType.datetime,
              style: TextStyle(color: themeColor.fgColor, fontSize: 20),
              controller: timeController,
              readOnly: true,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.alarm,
                      color: themeColor.fgColor,
                    ),
                    onPressed: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                            hour: int.parse(timeController.text.split(":")[0]),
                            minute:
                                int.parse(timeController.text.split(":")[1])),
                      );
                      if (time != null) {
                        timeController.text =
                            time.toString().substring(10).replaceAll(')', '');
                        _subFormKey2.currentState!.validate();
                      }
                      if (type == 'start') {
                        setState(() {});
                      }
                    },
                  ),
                  labelText: 'Enter the $type time',
                  border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)),
                      borderSide: BorderSide(color: themeColor.secondaryColor)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: themeColor.secondaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide:
                        BorderSide(color: themeColor.primaryColor, width: 2.0),
                  ),
                  labelStyle:
                      TextStyle(color: themeColor.fgColor.withOpacity(.6)),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  hintStyle: TextStyle(
                      color: themeColor.fgColor.withOpacity(.5), fontSize: 20),
                  hintText: "Start date ...",
                  // fillColor: themeColor.inputbgColor,
                  filled: true),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value?.isEmpty as bool) {
                  return 'The date should not be empty';
                }
                final duration = getDateTime(
                        endDateController.text, endTimeController.text)
                    .difference(getDateTime(
                        startDateController.text, startTimeController.text));
                if (duration.compareTo(const Duration(minutes: 10)) < 0 &&
                    type == 'end') {
                  return '\n';
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<RepeatType>> _getDropMenuItems() {
    return RepeatType.values
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(EnumToString.convertToString(item),
                  style: TextStyle(fontSize: 22, color: themeColor.fgColor)),
            ))
        .toList();
  }

  Widget _RepeatField() {
    return DropdownButtonFormField<RepeatType>(
      value: repeatType,
      dropdownColor: themeColor.bgColor,
      items: _getDropMenuItems(),
      onChanged: (value) {
        repeatType = value!;
        // setState(() {});
      },
      style: TextStyle(color: themeColor.fgColor, fontSize: 20),
      decoration: InputDecoration(
          labelText: 'Select the repeat type',
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: themeColor.secondaryColor)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: themeColor.secondaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: themeColor.primaryColor, width: 2.0),
          ),
          labelStyle: TextStyle(color: themeColor.fgColor.withOpacity(.6)),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintStyle: TextStyle(
              color: themeColor.fgColor.withOpacity(.5), fontSize: 20),
          hintText: "Select option",
          // fillColor: themeColor.inputbgColor,
          filled: true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null) {
          return 'select option for reminder';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeColor.bgColor,
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
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
                  const Spacer(),
                  // FloatingActionButton(
                  //   elevation: 4,
                  //   tooltip: 'Add',
                  //   backgroundColor: themeColor.primaryColor,
                  //   onPressed: () {
                  //     // Navigator.pushNamed(context, route.taskPage);
                  //   },
                  //   child: const Icon(
                  //     Icons.visibility,
                  //     size: 30,
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(

                      // color: themeColor.errorColor,
                      child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: BlocBuilder<CrudTaskBloc, CrudTaskState>(
                          builder: (context, state) {
                        switch (state.requestState) {
                          case StateStatus.LOADED:
                            return handleLoaded(context);
                          case StateStatus.LOADING:
                            return CustomLoadingProgress(
                                color: themeColor.primaryColor,
                                height: height * .8);
                          case StateStatus.ERROR:
                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              CustomSnakbarWidget(
                                      context: context,
                                      color: themeColor.errorColor)
                                  .show(state.errormessage ?? '');
                            });

                            break;
                          default:
                        }
                        return Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Text(
                                          (widget.task == null
                                                  ? 'Create'
                                                  : 'Update') +
                                              ' Task',
                                          style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w500,
                                              color: themeColor.fgColor)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          (widget.task == null
                                                  ? 'Create new'
                                                  : 'Update exist') +
                                              ' Task',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: themeColor.fgColor)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * .08,
                                ),
                                Showcase(
                                    key: _list[0],
                                    showcaseBackgroundColor:
                                        themeColor.drowerLightBgClor,
                                    textColor: themeColor.fgColor,
                                    description: 'Select a name for your task',
                                    child: _titleField()),
                                SizedBox(
                                  height: height * .08,
                                ),
                                Showcase(
                                    key: _list[1],
                                    showcaseBackgroundColor:
                                        themeColor.drowerLightBgClor,
                                    textColor: themeColor.fgColor,
                                    description:
                                        'Choose a description for your task',
                                    child: _descriptionField()),
                                SizedBox(
                                  height: height * .08,
                                ),
                                Showcase(
                                  key: _list[2],
                                  showcaseBackgroundColor:
                                      themeColor.drowerLightBgClor,
                                  textColor: themeColor.fgColor,
                                  description:
                                      'Select a start date end time for the task.\n     You can add a reminder to this task if the time is greater than 10 min of time now',
                                  child: _dateField(startDateController,
                                      startTimeController, 'start'),
                                ),
                                SizedBox(
                                  height: height * .08,
                                ),
                                Showcase(
                                  key: _list[3],
                                  showcaseBackgroundColor:
                                      themeColor.drowerLightBgClor,
                                  textColor: themeColor.fgColor,
                                  description:
                                      'Choose a end date and time and should be greater than the start date and time',
                                  child: _dateField(endDateController,
                                      endTimeController, 'end'),
                                ),
                                Visibility(
                                  visible: _setVisiblity() ||
                                      (widget.task != null &&
                                          widget.task?.reminder as bool),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: height * .08,
                                      ),
                                      Container(
                                        child: StatefulBuilder(
                                            builder: (context, setInnerState) {
                                          Widget dropDown = Container();
                                          if (reminder) {
                                            dropDown = _RepeatField();
                                          }
                                          return Column(
                                            children: [
                                              Showcase(
                                                  key: _list[5],
                                                  showcaseBackgroundColor:
                                                      themeColor
                                                          .drowerLightBgClor,
                                                  textColor: themeColor.fgColor,
                                                  description:
                                                      'Select the Repeat type \n choose none to run one time ',
                                                  child: dropDown),
                                              GestureDetector(
                                                onTap: () {
                                                  setInnerState(() {
                                                    reminder = !reminder;
                                                  });
                                                  if (reminder) {
                                                    if (showCaseConfig
                                                        .isLunched(
                                                            route.addTaskPage +
                                                                'repeat')) {
                                                      WidgetsBinding.instance
                                                          ?.addPostFrameCallback(
                                                        (_) =>
                                                            ShowCaseWidget.of(
                                                                    context)
                                                                .startShowCase(
                                                                    [_list[5]]),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Showcase(
                                                  key: _list[4],
                                                  showcaseBackgroundColor:
                                                      themeColor
                                                          .drowerLightBgClor,
                                                  textColor: themeColor.fgColor,
                                                  disposeOnTap: true,
                                                  onTargetClick: () {
                                                    setInnerState(() {
                                                      reminder = !reminder;
                                                    });
                                                    if (reminder) {
                                                      if (showCaseConfig
                                                          .isLunched(route
                                                                  .addTaskPage +
                                                              'repeat')) {
                                                        WidgetsBinding.instance
                                                            ?.addPostFrameCallback(
                                                          (_) => ShowCaseWidget
                                                                  .of(context)
                                                              .startShowCase(
                                                                  [_list[5]]),
                                                        );
                                                      }
                                                    }
                                                  },
                                                  description:
                                                      'Click to add reminder to this task',
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                        value: reminder,
                                                        onChanged: (value) {
                                                          setInnerState(() {
                                                            reminder = value!;
                                                          });
                                                        },
                                                      ),
                                                      Text('Activate Reminder',
                                                          style: TextStyle(
                                                              letterSpacing: 2,
                                                              fontSize: 22,
                                                              color: reminder
                                                                  ? themeColor
                                                                      .primaryColor
                                                                  : themeColor
                                                                      .fgColor)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * .08,
                                ),
                                Showcase(
                                  key: _list[6],
                                  showcaseBackgroundColor:
                                      themeColor.drowerLightBgClor,
                                  textColor: themeColor.fgColor,
                                  description:
                                      'Click to add the task to your category',
                                  child: GestureDetector(
                                    onTap: handleRequest,
                                    child: Container(
                                      width: width,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: themeColor.primaryColor),
                                      child: Text(
                                          (widget.task == null
                                              ? 'create'
                                              : 'Update'),
                                          style: const TextStyle(
                                              letterSpacing: 2,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * .08,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _setVisiblity() {
    print('visisisisisisi');
    final duration =
        getDateTime(startDateController.text, startTimeController.text)
            .difference(DateTime.now());
    bool result = duration.compareTo(const Duration(minutes: 10)) >= 0;
    if (result) {
      if (showCaseConfig.isLunched(route.addTaskPage + 'reminder')) {
        WidgetsBinding.instance?.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([_list[4]]),
        );
      }
    }
    return result;
  }

  void handleRequest() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final _task = Task(
        categoryId: widget.categoryId,
        title: nameController.text,
        description: descriptionController.text,
        startDateTime:
            getDateTime(startDateController.text, startTimeController.text),
        endDateTime:
            getDateTime(endDateController.text, endTimeController.text),
        status: widget.task != null ? widget.task?.status : TaskStatus.TODO,
        reminder: reminder,
        notificationId:
            widget.task != null ? widget.task?.notificationId : null,
        repeatType: !reminder ? null : repeatType);
    nameController.clear();
    descriptionController.clear();
    if (widget.task == null) {
      context
          .read<CrudTaskBloc>()
          .add(CrudTaskEvent(requestEvent: CrudEventStatus.ADD, task: _task));
    } else {
      _task.id = widget.task?.id;

      context
          .read<CrudTaskBloc>()
          .add(CrudTaskEvent(requestEvent: CrudEventStatus.EDIT, task: _task));
    }
  }

  DateTime getDateTime(String text1, String text2) {
    return DateTime.parse(text1.replaceAll(' ', '') + ' ' + text2 + ":00");
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    startTimeController.dispose();
    endDateController.dispose();
    endTimeController.dispose();
  }

  Widget handleLoaded(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        CustomSnakbarWidget(context: context).show("The task was " +
            (widget.task == null ? 'created' : 'Updated') +
            'successfuly');
        widget.task = null;
      });
    });
    context
        .read<TodayBloc>()
        .add(TodayEvent(requestEvent: CrudEventStatus.FETCH));
    context
        .read<ReminderBloc>()
        .add(ReminderEvent(requestEvent: ReminderEventStatus.TODAY));
    context.read<TaskBloc>().add(TaskEvent(
        requestEvent: CrudEventStatus.FETCH,
        date: DateTime.now(),
        categoryId: widget.categoryId!));
    context
        .read<CategoryBloc>()
        .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));
    context
        .read<CrudTaskBloc>()
        .add(CrudTaskEvent(requestEvent: CrudEventStatus.RESET));

    return Container();
  }
}
