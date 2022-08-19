import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_state.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/widgets/custum_progress.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:showcaseview/showcaseview.dart';

class CategoryPage extends StatefulWidget {
  Category category;
  CategoryPage({required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();
  final GlobalKey _first = GlobalKey();
  final GlobalKey _second = GlobalKey();
  final GlobalKey _thirth = GlobalKey();
  final GlobalKey _forth = GlobalKey();
  final GlobalKey _fifth = GlobalKey();
  final GlobalKey _sixth = GlobalKey();
  final GlobalKey _seventh = GlobalKey();
  double donePercent = 0;
  double undonePercent = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    donePercent =
        widget.category.numberTaskDone! / (widget.category.numberTask!);
    undonePercent =
        widget.category.numberTaskDone! / (widget.category.numberTask!);
    if (showCaseConfig.isLunched(route.categoryPage)) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(Duration(seconds: 1)).then((value) =>
            ShowCaseWidget.of(context).startShowCase(
                [_first, _second, _thirth, _forth, _fifth, _sixth, _seventh])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeColor.bgColor,
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state.requestState == StateStatus.LOADED) {
            widget.category = state.categories?.firstWhere(
                (element) => element.id == widget.category.id,
                orElse: () => Category()) as Category;
            donePercent =
                widget.category.numberTaskDone! / (widget.category.numberTask!);
            undonePercent =
                widget.category.numberTaskDone! / (widget.category.numberTask!);
            setState(() {});
          }
        },
        child: Column(
          children: [
            SizedBox(
              height: 15,
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
                  Showcase(
                    key: _first,
                    showcaseBackgroundColor: themeColor.drowerLightBgClor,
                    textColor: themeColor.fgColor,
                    description: 'Here you can see the details of category',
                    child: Text(widget.category.name!.toUpperCase(),
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: themeColor.fgColor)),
                  ),
                  Spacer(),
                  Showcase(
                    key: _seventh,
                    showcaseBackgroundColor: themeColor.drowerLightBgClor,
                    textColor: themeColor.fgColor,
                    shapeBorder: CircleBorder(),
                    disposeOnTap: true,
                    onTargetClick: () {
                      Navigator.pushNamed(context, route.taskPage,
                          arguments: widget.category.id);
                    },
                    description:
                        'Click to see the task scuduler of this category',
                    child: FloatingActionButton(
                      elevation: 4,
                      tooltip: 'View',
                      backgroundColor: themeColor.primaryColor,
                      onPressed: () {
                        Navigator.pushNamed(context, route.taskPage,
                            arguments: widget.category.id);
                      },
                      child: const Icon(
                        Icons.visibility,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      color: themeColor.drowerBgClor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      "Status ",
                                      style: TextStyle(
                                          color: themeColor.fgColor,
                                          fontSize: 21),
                                    ),
                                    Spacer(),
                                    Showcase(
                                      key: _sixth,
                                      showcaseBackgroundColor:
                                          themeColor.drowerLightBgClor,
                                      textColor: themeColor.fgColor,
                                      disposeOnTap: true,
                                      onTargetClick: () {
                                        Navigator.pushNamed(
                                            context, route.addTaskPage,
                                            arguments: {
                                              'categoryId': widget.category.id
                                            }).then((_) {
                                          setState(() {
                                            ShowCaseWidget.of(context)
                                                .startShowCase([_seventh]);
                                          });
                                        });
                                      },
                                      description:
                                          'Click here to add task to this category',
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, route.addTaskPage,
                                              arguments: {
                                                'categoryId': widget.category.id
                                              });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: themeColor.primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Add Task ",
                                              style: TextStyle(
                                                  color:
                                                      themeColor.primaryColor,
                                                  fontSize: 21),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Showcase(
                              key: _second,
                              showcaseBackgroundColor:
                                  themeColor.drowerLightBgClor,
                              textColor: themeColor.fgColor,
                              description:
                                  'Here you can see the status of category',
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomProgress(
                                  percent: donePercent,
                                  themeColor: themeColor,
                                  radius: 200,
                                  lineWidth: 10,
                                  textColor: themeColor.fgColor,
                                  textSize: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 0,
                      maxHeight: height * .2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        child: Text('        ' + widget.category.description!,
                            style: TextStyle(
                                fontSize: 20, color: themeColor.fgColor)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: themeColor.drowerBgClor,
                      child: Showcase(
                        key: _thirth,
                        showcaseBackgroundColor: themeColor.drowerLightBgClor,
                        textColor: themeColor.fgColor,
                        description:
                            'Here you can see the total number of tasks that have the current category',
                        child: ListTile(
                            title: RichText(
                          text: TextSpan(
                            text: 'Total of Tasks : ',
                            style: TextStyle(
                                fontSize: 21, color: themeColor.fgColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.category.numberTask.toString(),
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: themeColor.secondaryColor)),
                            ],
                          ),
                        )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: themeColor.drowerBgClor,
                      child: Showcase(
                        key: _forth,
                        showcaseBackgroundColor: themeColor.drowerLightBgClor,
                        textColor: themeColor.fgColor,
                        description:
                            'Here is the number of done tasks of category',
                        child: ListTile(
                            title: RichText(
                          text: TextSpan(
                            text: 'Total of done Tasks : ',
                            style: TextStyle(
                                fontSize: 21, color: themeColor.fgColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      widget.category.numberTaskDone.toString(),
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: themeColor.secondaryColor)),
                            ],
                          ),
                        )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: themeColor.drowerBgClor,
                      child: Showcase(
                        key: _fifth,
                        showcaseBackgroundColor: themeColor.drowerLightBgClor,
                        textColor: themeColor.fgColor,
                        description:
                            'Here the number of tasks not yet completed category',
                        child: ListTile(
                            title: RichText(
                          text: TextSpan(
                            text: 'Total of undone Tasks : ',
                            style: TextStyle(
                                fontSize: 21, color: themeColor.fgColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: (widget.category.numberTask! -
                                          widget.category.numberTaskDone!)
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: themeColor.secondaryColor)),
                            ],
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
