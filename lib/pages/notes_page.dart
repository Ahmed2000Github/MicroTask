import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
import 'package:microtask/widgets/custom_appbar_widget.dart';
import 'package:microtask/widgets/no_data_found_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class NotesPage extends StatefulWidget {
  bool? rotate;
  NotesPage({this.rotate});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  Configuration get configuration => GetIt.I<Configuration>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();

  final GlobalKey _first = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<NoteCubit>().changeState();

    if (showCaseConfig.isLunched(route.notesPage)) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(const Duration(seconds: 1)).then(
            (value) => ShowCaseWidget.of(context).startShowCase([_first])),
      );
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
          Showcase(
              showcaseBackgroundColor: themeColor.drowerLightBgClor,
              textColor: themeColor.fgColor,
              description: AppLocalizations.of(context)?.notesd1 ?? '',
              key: _first,
              child: CustomAppBar(
                  title: AppLocalizations.of(context)?.notes ?? '')),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 8, 0),
            child: Column(
              children: [
                Lottie.asset('assets/lotties/check_list.json',
                    height: 200, width: 300),
                Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: BlocBuilder<NoteCubit, List<Note>>(
                          builder: (context, notes) {
                        return RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: AppLocalizations.of(context)?.youHave ?? '',
                            style: TextStyle(
                              fontFamily: configuration.currentFont,
                              color: themeColor.fgColor,
                              fontSize: 22,
                            ),
                          ),
                          TextSpan(
                            text: ' ${notes.length} ',
                            style: TextStyle(
                              fontFamily: configuration.currentFont,
                              color: themeColor.secondaryColor,
                              fontSize: 22,
                            ),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)?.notes ?? '',
                            style: TextStyle(
                              fontFamily: configuration.currentFont,
                              color: themeColor.fgColor,
                              fontSize: 22,
                            ),
                          ),
                        ]));
                      }),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          context.read<NoteCubit>().changeState();
                        },
                        icon: Icon(
                          Icons.sync,
                          size: 30,
                          color: themeColor.primaryColor,
                        ))
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<NoteCubit, List<Note>>(
              builder: (context, notes) {
                if (notes.isEmpty) {
                  return NoDataFoundWidget(
                      text: AppLocalizations.of(context)?.noNoteFound ?? '');
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: GridView.builder(
                      itemCount: notes.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemBuilder: (BuildContext ctx, index) {
                        var note = notes[index];
                        var description = note.description;
                        var length = description?.length as int;
                        if (length > 50) {
                          description =
                              (description?.substring(0, 50) ?? '') + '...';
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, route.notePage,
                                arguments: {'noteId': note.id});
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: themeColor.drowerBgClor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  ListTile(
                                    horizontalTitleGap: 0,
                                    leading: Icon(
                                      Icons.note_alt_rounded,
                                      color: themeColor.primaryLightColor,
                                      size: 20,
                                    ),
                                    trailing: PopupMenuButton(
                                      color: themeColor.drowerLightBgClor,
                                      child: Icon(
                                        Icons.more_vert,
                                        size: 20,
                                        color: themeColor.fgColor,
                                      ),
                                      itemBuilder: (context) =>
                                          getMenuItems(note),
                                      onSelected: (result) {
                                        if (result == 0) {
                                          Navigator.pushNamed(
                                              context, route.notePage,
                                              arguments: {'noteId': note.id});
                                        } else if (result == 1) {
                                          Navigator.pushNamed(
                                              context, route.addNotePage,
                                              arguments: {'note': note});
                                        } else if (result == 2) {
                                          context.read<CrudNoteBloc>().add(
                                              NoteEvent(
                                                  eventState:
                                                      CrudEventStatus.DELETE,
                                                  note: note));
                                        }
                                      },
                                    ),
                                    title: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        note.title ?? '',
                                        style: TextStyle(
                                          fontFamily: configuration.currentFont,
                                          color: themeColor.fgColor,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Text(
                                          '  ${description}',
                                          style: TextStyle(
                                            fontFamily:
                                                configuration.currentFont,
                                            color: themeColor.fgColor,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Text(
                                      DateFormat("dd-MM-yy")
                                          .format(note.createdAt!),
                                      style: TextStyle(
                                        fontFamily: configuration.currentFont,
                                        color: themeColor.secondaryColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: Text(
                                      DateFormat("HH:mm")
                                          .format(note.createdAt!),
                                      style: TextStyle(
                                        fontFamily: configuration.currentFont,
                                        color: themeColor.secondaryColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        );
                      }),
                );
              },
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, route.addNotePage,
              arguments: {'e': 'e'});
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  List<PopupMenuEntry> getMenuItems(Note note) {
    List<PopupMenuEntry> list = [];
    list.add(PopupMenuItem(
      value: 0,
      child: Center(
        child: Icon(
          Icons.remove_red_eye,
          color: themeColor.secondaryColor,
          size: 30,
        ),
      ),
    ));
    list.add(PopupMenuItem(
      value: 1,
      child: Center(
        child: Icon(
          Icons.edit_note,
          color: themeColor.primaryColor,
          size: 30,
        ),
      ),
    ));
    list.add(PopupMenuItem(
      value: 2,
      child: Center(
        child: Icon(
          Icons.delete_outline,
          color: themeColor.errorColor,
          size: 30,
        ),
      ),
    ));
    return list;
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
