import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_state.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/widgets/custum_progress.dart';
import 'package:microtask/configurations/route.dart' as route;

class CategoryPage extends StatefulWidget {
  Category category;
  CategoryPage({required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  double donePercent = 0;
  double undonePercent = 0;

  @override
  void initState() {
    super.initState();
    donePercent =
        widget.category.numberTaskDone! / (widget.category.numberTask!);
    undonePercent =
        widget.category.numberTaskDone! / (widget.category.numberTask!);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
        child: ListView(
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
                  Text(widget.category.name!.toUpperCase(),
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: themeColor.fgColor)),
                  Spacer(),
                  FloatingActionButton(
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
                ],
              ),
            ),
            SizedBox(
              height: height * .85,
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
                                    GestureDetector(
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
                                                color: themeColor.primaryColor,
                                                fontSize: 21),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: themeColor.drowerBgClor,
                      child: ListTile(
                          title: RichText(
                        text: TextSpan(
                          text: 'Total of done Tasks : ',
                          style: TextStyle(
                              fontSize: 21, color: themeColor.fgColor),
                          children: <TextSpan>[
                            TextSpan(
                                text: widget.category.numberTaskDone.toString(),
                                style: TextStyle(
                                    fontSize: 21,
                                    color: themeColor.secondaryColor)),
                          ],
                        ),
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: themeColor.drowerBgClor,
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
