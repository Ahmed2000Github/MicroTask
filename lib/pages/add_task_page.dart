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
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/services/enum_translate_services.dart';
import 'package:microtask/widgets/custom_appbar_widget.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/custom_snakbar_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskPage extends StatefulWidget {
  Task? task;
  String? categoryId;
  bool? rotate;
  Map<String, dynamic> data;

  AddTaskPage({Key? key, required this.data}) : super(key: key) {
    task = data['task'];
    categoryId = data['categoryId'];
    rotate = data['rotate'];
  }

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _subFormKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _subFormKey2 = GlobalKey<FormState>();

  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  Configuration get configuration => GetIt.I<Configuration>();
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
      print(widget.task?.repeatType);
      repeatType = widget.task?.repeatType;
      reminder = widget.task?.reminder as bool;
    }
    if (showCaseConfig.isLunched(route.addTaskPage)) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(Duration(seconds: 1))
            .then((value) => ShowCaseWidget.of(context).startShowCase(_list)),
      );
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  //  {
  Widget _titleField() {
    return TextFormField(
      style: TextStyle(
          fontFamily: configuration.currentFont,
          color: themeColor.fgColor,
          fontSize: 20),
      controller: nameController,
      decoration: InputDecoration(
          labelText: AppLocalizations.of(context)?.addTaskName ?? '',
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
          labelStyle: TextStyle(
              fontFamily: configuration.currentFont,
              color: themeColor.fgColor.withOpacity(.6)),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintStyle: TextStyle(
              fontFamily: configuration.currentFont,
              color: themeColor.fgColor.withOpacity(.5),
              fontSize: 20),
          hintText: AppLocalizations.of(context)?.addTaskNameP ?? '',
          // fillColor: themeColor.inputbgColor,
          filled: true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value?.isEmpty as bool) {
          return AppLocalizations.of(context)?.addTaskNameV1 ?? '';
        }
        if (value?.length as int > 12) {
          return AppLocalizations.of(context)?.addTaskNameV2 ?? '';
        }
      },
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      minLines: 1,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      style: TextStyle(
          fontFamily: configuration.currentFont,
          color: themeColor.fgColor,
          fontSize: 20),
      controller: descriptionController,
      decoration: InputDecoration(
          labelText: AppLocalizations.of(context)?.addTaskDescription ?? '',
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
          labelStyle: TextStyle(
              fontFamily: configuration.currentFont,
              color: themeColor.fgColor.withOpacity(.6)),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintStyle: TextStyle(
              fontFamily: configuration.currentFont,
              color: themeColor.fgColor.withOpacity(.5),
              fontSize: 20),
          hintText: AppLocalizations.of(context)?.addTaskDescriptionP ?? '',
          // fillColor: themeColor.inputbgColor,
          filled: true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value?.isEmpty as bool) {
          return AppLocalizations.of(context)?.addTaskDescriptionV1 ?? '';
        }
      },
    );
  }

  Widget _dateField(TextEditingController dateController,
      TextEditingController timeController, String type) {
    var transType = AppLocalizations.of(context)?.end ?? '';
    if (type == 'start') {
      transType = AppLocalizations.of(context)?.start ?? '';
    }
    return Form(
      key: type == 'end' ? _subFormKey2 : _subFormKey1,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: TextFormField(
              keyboardType: TextInputType.datetime,
              style: TextStyle(
                  fontFamily: configuration.currentFont,
                  color: themeColor.fgColor,
                  fontSize: 20),
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
                          locale: Locale(
                              AppLocalizations.of(context)?.localeName ?? ''),
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
                  labelText:
                      AppLocalizations.of(context)?.addTaskDate(transType) ??
                          '',
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
                  labelStyle: TextStyle(
                      fontFamily: configuration.currentFont,
                      color: themeColor.fgColor.withOpacity(.6)),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  hintStyle: TextStyle(
                      fontFamily: configuration.currentFont,
                      color: themeColor.fgColor.withOpacity(.5),
                      fontSize: 20),
                  // hintText: "Start date ...",
                  filled: true),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                // if (value?.isEmpty as bool) {
                //   return 'The date should not be empty';
                // }
                final duration = getDateTime(
                        endDateController.text, endTimeController.text)
                    .difference(getDateTime(
                        startDateController.text, startTimeController.text));
                if (duration.compareTo(const Duration(minutes: 10)) < 0 &&
                    type == 'end') {
                  return AppLocalizations.of(context)?.addTaskDateV1 ?? '';
                }
              },
            ),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * .35,
            child: TextFormField(
              keyboardType: TextInputType.datetime,
              style: TextStyle(
                  fontFamily: configuration.currentFont,
                  color: themeColor.fgColor,
                  fontSize: 20),
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
                        helpText:
                            AppLocalizations.of(context)?.selectTime ?? '',
                        cancelText: AppLocalizations.of(context)?.cancel ?? '',
                        confirmText: AppLocalizations.of(context)?.ok ?? '',
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
                  labelText:
                      AppLocalizations.of(context)?.addTaskTime(transType) ??
                          '',
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
                  labelStyle: TextStyle(
                      fontFamily: configuration.currentFont,
                      color: themeColor.fgColor.withOpacity(.6)),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  hintStyle: TextStyle(
                      fontFamily: configuration.currentFont,
                      color: themeColor.fgColor.withOpacity(.5),
                      fontSize: 20),
                  // hintText: "Start date ...",
                  // fillColor: themeColor.inputbgColor,
                  filled: true),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                // if (value?.isEmpty as bool) {
                //   return 'The date should not be empty';
                // }
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
              child: Text(
                  EnumTranslateServices.translateTaskRepeatType(context, item),
                  style: TextStyle(
                      fontFamily: configuration.currentFont,
                      fontSize: 22,
                      color: themeColor.fgColor)),
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
      style: TextStyle(
          fontFamily: configuration.currentFont,
          color: themeColor.fgColor,
          fontSize: 20),
      decoration: InputDecoration(
          labelText: AppLocalizations.of(context)?.addTaskRepeat ?? '',
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
          labelStyle: TextStyle(
              fontFamily: configuration.currentFont,
              color: themeColor.fgColor.withOpacity(.6)),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintStyle: TextStyle(
              fontFamily: configuration.currentFont,
              color: themeColor.fgColor.withOpacity(.5),
              fontSize: 20),
          hintText: AppLocalizations.of(context)?.addTaskRepeatP ?? '',
          // fillColor: themeColor.inputbgColor,
          filled: true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null) {
          return AppLocalizations.of(context)?.addTaskRepeatV1 ?? '';
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
            CustomAppBar(title: ''),
            Expanded(
              child: Column(
                children: [
                  Expanded(
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
                                              fontFamily:
                                                  configuration.currentFont,
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
                                              fontFamily:
                                                  configuration.currentFont,
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
                                    description: AppLocalizations.of(context)
                                            ?.addTaskd1 ??
                                        '',
                                    child: _titleField()),
                                SizedBox(
                                  height: height * .08,
                                ),
                                Showcase(
                                    key: _list[1],
                                    showcaseBackgroundColor:
                                        themeColor.drowerLightBgClor,
                                    textColor: themeColor.fgColor,
                                    description: AppLocalizations.of(context)
                                            ?.addTaskd2 ??
                                        '',
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
                                      AppLocalizations.of(context)?.addTaskd3 ??
                                          '',
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
                                      AppLocalizations.of(context)?.addTaskd4 ??
                                          '',
                                  child: _dateField(endDateController,
                                      endTimeController, 'end'),
                                ),
                                SizedBox(
                                  height: height * .08,
                                ),
                                Showcase(
                                    key: _list[5],
                                    showcaseBackgroundColor:
                                        themeColor.drowerLightBgClor,
                                    textColor: themeColor.fgColor,
                                    description: AppLocalizations.of(context)
                                            ?.addTaskd5 ??
                                        '',
                                    child: _RepeatField()),
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
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setInnerState(() {
                                                    reminder = !reminder;
                                                  });
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
                                                      AppLocalizations.of(
                                                                  context)
                                                              ?.addTaskd6 ??
                                                          '',
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
                                                      Text(
                                                          AppLocalizations.of(
                                                                      context)
                                                                  ?.activateRenminder ??
                                                              '',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  configuration
                                                                      .currentFont,
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
                                      AppLocalizations.of(context)?.addTaskd7 ??
                                          '',
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
                                              ? AppLocalizations.of(context)
                                                      ?.create ??
                                                  ''
                                              : AppLocalizations.of(context)
                                                      ?.update ??
                                                  ''),
                                          style: TextStyle(
                                              fontFamily:
                                                  configuration.currentFont,
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
        repeatType: repeatType);
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
    if (widget.rotate != null) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      super.dispose();
      nameController.dispose();
      descriptionController.dispose();
      startDateController.dispose();
      startTimeController.dispose();
      endDateController.dispose();
      endTimeController.dispose();
    }
  }

  Widget handleLoaded(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.pop(context, true);
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        widget.task = null;
      });
    });
    context
        .read<ReminderBloc>()
        .add(ReminderEvent(requestEvent: ReminderEventStatus.TODAY));
    context
        .read<CrudTaskBloc>()
        .add(CrudTaskEvent(requestEvent: CrudEventStatus.RESET));

    return Container();
  }
}
