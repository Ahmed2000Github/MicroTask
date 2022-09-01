import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_state.dart';
import 'package:microtask/blocs/note/one_note_cubit.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/models/note_model.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/widgets/custom_appbar_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class NotePage extends StatefulWidget {
  late String noteId;
  bool? rotate;
  Map<String, dynamic> data;
  NotePage({required this.data}) {
    noteId = data['noteId'];
    rotate = data['rotate'];
  }
  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  Configuration get configuration => GetIt.I<Configuration>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();

  final GlobalKey _first = GlobalKey();
  final GlobalKey _second = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<OneNoteCubit>().changeState(widget.noteId);

    if (showCaseConfig.isLunched(route.notesPage)) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(const Duration(seconds: 1)).then((value) =>
            ShowCaseWidget.of(context).startShowCase([_first, _second])),
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeColor.bgColor,
      body: BlocBuilder<OneNoteCubit, Map<String, dynamic>>(
          builder: (context, state) {
        var note = state['note'] as Note;
        var task = state['task'] as Task;
        return BlocListener<CrudTaskBloc, CrudTaskState>(
          listener: (context, state) {
            context.read<OneNoteCubit>().changeState(widget.noteId);
          },
          child: Stack(
            children: [
              Container(
                height: width * .9,
                width: width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                      themeColor.primaryColor,
                      Color.fromARGB(255, 4, 122, 226)
                    ]),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(width))),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, width * .3, 8, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Showcase(
                        showcaseBackgroundColor: themeColor.drowerLightBgClor,
                        textColor: themeColor.fgColor,
                        description:
                            AppLocalizations.of(context)?.showNoted1 ?? '',
                        key: _first,
                        child: FittedBox(
                          child: Text(
                            note.title!,
                            style: TextStyle(
                              fontFamily: configuration.currentFont,
                              color: Colors.white,
                              fontSize: 38,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: width * .5,
                        child: Text(
                          Intl.DateFormat("yyyy-MM-dd").format(note.updatedAt!),
                          style: TextStyle(
                            fontFamily: configuration.currentFont,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: width * .91,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: width,
                      width: width * .97,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 140,
                            child: Card(
                              color: themeColor.drowerBgClor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)
                                                ?.noteLinkedTask ??
                                            '',
                                        style: TextStyle(
                                          fontFamily: configuration.currentFont,
                                          color: themeColor.fgColor,
                                          fontSize: 28,
                                        )),
                                    const Divider(
                                      height: 10,
                                      thickness: 2,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Showcase(
                                          showcaseBackgroundColor:
                                              themeColor.drowerLightBgClor,
                                          textColor: themeColor.fgColor,
                                          description:
                                              AppLocalizations.of(context)
                                                      ?.showNoted2 ??
                                                  '',
                                          key: _second,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (note.taskId != null) {
                                                Navigator.pushNamed(
                                                    context, route.showTaskPage,
                                                    arguments: {
                                                      'taskId': task.id,
                                                    });
                                              }
                                            },
                                            child: Text(
                                                note.taskId == null
                                                    ? (AppLocalizations.of(
                                                                context)
                                                            ?.noteNoTask ??
                                                        '')
                                                    : task.title!,
                                                style: TextStyle(
                                                  fontFamily:
                                                      configuration.currentFont,
                                                  color: themeColor
                                                      .primaryLightColor,
                                                  fontSize: 22,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * .4,
                            child: Card(
                              color: themeColor.drowerBgClor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)
                                                ?.description ??
                                            '',
                                        style: TextStyle(
                                          fontFamily: configuration.currentFont,
                                          color: themeColor.fgColor,
                                          fontSize: 28,
                                        )),
                                    const Divider(
                                      height: 10,
                                      thickness: 2,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('   ' + note.description!,
                                              style: TextStyle(
                                                fontFamily:
                                                    configuration.currentFont,
                                                color: themeColor.fgColor,
                                                fontSize: 18,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              Positioned(
                left: width * .4,
                top: width * .15,
                child: Image.asset(
                  'assets/images/note_image.png',
                  fit: BoxFit.fill,
                  width: width * .8,
                ),
              ),
              CustomAppBar(textColor: Colors.white, title: ''),
            ],
          ),
        );
      }),
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
