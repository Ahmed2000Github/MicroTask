import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/note/note_crud_bloc.dart';
import 'package:microtask/blocs/note/note_cubit.dart';
import 'package:microtask/blocs/note/note_event.dart';
import 'package:microtask/blocs/note/note_state.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/note_model.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/widgets/custom_appbar_widget.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/custom_snakbar_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uuid/uuid.dart';

class AddNotePage extends StatefulWidget {
  Note? note;
  Task? task;
  bool? rotate;
  Map<String, dynamic> data;
  AddNotePage({required this.data}) {
    task = data['task'];
    note = data['note'];
    rotate = data['rotate'];
  }
  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  Configuration get configuration => GetIt.I<Configuration>();

  ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final GlobalKey _first = GlobalKey();

  final GlobalKey _second = GlobalKey();

  final GlobalKey _thirth = GlobalKey();
  final GlobalKey _forth = GlobalKey();

  Alignment? alignment;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note?.title as String;
      descriptionController.text = widget.note?.description as String;
    }
    context
        .read<CrudNoteBloc>()
        .add(NoteEvent(eventState: CrudEventStatus.RESET));
    if (showCaseConfig.isLunched(route.addNotePage)) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(const Duration(seconds: 1)).then((value) =>
            ShowCaseWidget.of(context)
                .startShowCase([_first, _second, _thirth, _forth])),
      );
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    alignment = Alignment.centerRight;
    if (AppLocalizations.of(context)?.localeName == 'ar') {
      alignment = Alignment.centerLeft;
    }
    return Scaffold(
      backgroundColor: themeColor.bgColor,
      body: Column(children: [
        CustomAppBar(title: ''),
        Showcase(
          showcaseBackgroundColor: themeColor.drowerLightBgClor,
          textColor: themeColor.fgColor,
          description: AppLocalizations.of(context)?.addNoted1 ?? '',
          key: _first,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.note != null
                  ? (AppLocalizations.of(context)?.updateNote ?? '')
                  : AppLocalizations.of(context)?.createNote ?? '',
              style: TextStyle(
                  fontFamily: configuration.currentFont,
                  color: themeColor.fgColor,
                  fontSize: 25),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                BlocBuilder<CrudNoteBloc, NoteState>(builder: (context, state) {
              switch (state.requestState) {
                case StateStatus.LOADED:
                  SchedulerBinding.instance?.addPostFrameCallback(
                    (_) {
                      Navigator.pop(context, true);
                      context
                          .read<CrudNoteBloc>()
                          .add(NoteEvent(eventState: CrudEventStatus.RESET));
                    },
                  );

                  return Container();
                case StateStatus.LOADING:
                  return CustomLoadingProgress(
                      color: themeColor.primaryColor, height: height * .8);
                case StateStatus.ERROR:
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    CustomSnakbarWidget(
                            context: context, color: themeColor.errorColor)
                        .show(state.errorMessage ?? '');
                  });
                  context
                      .read<CrudNoteBloc>()
                      .add(NoteEvent(eventState: CrudEventStatus.RESET));
                  break;
                default:
              }
              return Form(
                key: _formKey,
                child: Center(
                  child: ListView(
                    children: [
                      Showcase(
                          showcaseBackgroundColor: themeColor.drowerLightBgClor,
                          textColor: themeColor.fgColor,
                          description:
                              AppLocalizations.of(context)?.addNoted2 ?? '',
                          key: _second,
                          child: _titleField()),
                      const SizedBox(
                        height: 30,
                      ),
                      Showcase(
                        showcaseBackgroundColor: themeColor.drowerLightBgClor,
                        textColor: themeColor.fgColor,
                        description:
                            AppLocalizations.of(context)?.addNoted3 ?? '',
                        key: _thirth,
                        child: SizedBox(
                          height: height * .5,
                          child: _descriptionField(),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        alignment: alignment,
                        child: SizedBox(
                          height: 60,
                          width: width * .5,
                          child: Showcase(
                            showcaseBackgroundColor:
                                themeColor.drowerLightBgClor,
                            textColor: themeColor.fgColor,
                            description:
                                AppLocalizations.of(context)?.addNoted4 ?? '',
                            key: _forth,
                            child: GestureDetector(
                              onTap: () {
                                handleSubmit();
                              },
                              child: Card(
                                color: themeColor.primaryColor,
                                child: Center(
                                  child: Text(
                                    widget.note != null
                                        ? (AppLocalizations.of(context)
                                                ?.update ??
                                            '')
                                        : AppLocalizations.of(context)
                                                ?.create ??
                                            '',
                                    style: TextStyle(
                                        fontFamily: configuration.currentFont,
                                        color: Colors.white,
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        )
      ]),
    );
  }

  Widget _titleField() {
    return TextFormField(
      style: TextStyle(
          fontFamily: configuration.currentFont,
          color: themeColor.fgColor,
          fontSize: 20),
      controller: titleController,
      decoration: InputDecoration(
          labelText: AppLocalizations.of(context)?.addNoteTitle ?? '',
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
          hintText: AppLocalizations.of(context)?.addNoteTitleP ?? '',
          // fillColor: themeColor.inputbgColor,
          filled: true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value?.isEmpty as bool) {
          return AppLocalizations.of(context)?.addNoteTitleV1 ?? '';
        }
        if (value?.length as int > 20) {
          return AppLocalizations.of(context)?.addNoteTitleV2 ?? '';
        }
      },
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      maxLines: 20,
      keyboardType: TextInputType.multiline,
      style: TextStyle(
          fontFamily: configuration.currentFont,
          color: themeColor.fgColor,
          fontSize: 20),
      controller: descriptionController,
      decoration: InputDecoration(
          isDense: true,
          labelText: AppLocalizations.of(context)?.addNoteDescription ?? '',
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
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
          hintStyle: TextStyle(
              fontFamily: configuration.currentFont,
              color: themeColor.fgColor.withOpacity(.5),
              fontSize: 20),
          hintText: AppLocalizations.of(context)?.addNoteDescriptionP ?? '',
          // fillColor: themeColor.inputbgColor,
          filled: true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value?.isEmpty as bool) {
          return AppLocalizations.of(context)?.addNoteDescriptionV1 ?? '';
        }
      },
    );
  }

  void handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    print("fffffffff ${widget.task}");
    var note = Note(
      id: widget.note?.id ?? const Uuid().v1(),
      title: titleController.text,
      description: descriptionController.text,
      createdAt: widget.note != null ? widget.note?.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );
    if (widget.task != null) {
      note.taskId = widget.task?.id;
      widget.task?.noteId = note.id;
      context.read<CrudTaskBloc>().add(
          CrudTaskEvent(requestEvent: CrudEventStatus.EDIT, task: widget.task));
    }
    if (widget.note != null) {
      context
          .read<CrudNoteBloc>()
          .add(NoteEvent(eventState: CrudEventStatus.EDIT, note: note));
    } else {
      context
          .read<CrudNoteBloc>()
          .add(NoteEvent(eventState: CrudEventStatus.ADD, note: note));
    }
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
