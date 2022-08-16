import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/category/category_state.dart';
import 'package:microtask/blocs/crud_category/crud_category_bloc.dart';
import 'package:microtask/blocs/crud_category/crud_category_event.dart';
import 'package:microtask/blocs/today/today_bloc.dart';
import 'package:microtask/blocs/today/today_event.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/no_data_found_widget.dart';

class CategoriesPage extends StatefulWidget {
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  @override
  void initState() {
    super.initState();
    context
        .read<CategoryBloc>()
        .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeColor.bgColor,
      body: Column(
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
                const Spacer(),
                Text('Categories',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: themeColor.fgColor)),
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
          BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
            switch (state.requestState) {
              case StateStatus.NONE:
                context
                    .read<CategoryBloc>()
                    .add(CategoryEvent(requestEvent: CrudEventStatus.FETCH));
                return Container();
              case StateStatus.LOADING:
                return CustomLoadingProgress(
                    color: themeColor.primaryColor, height: height * .4);
              case StateStatus.LOADED:
                if (state.categories?.isEmpty as bool) {
                  return Expanded(
                    child: SizedBox(
                      child: NoDataFoundWidget(
                        text: 'Not Category found',
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 8, 10),
                        child: RichText(
                          text: TextSpan(
                            text: 'Total of Categories: ',
                            style: TextStyle(
                                fontSize: 21, color: themeColor.fgColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: (state.categories?.length).toString(),
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: themeColor.secondaryColor)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.categories?.length,
                          itemBuilder: (context, index) {
                            var category = state.categories?[index];
                            double percent = (category?.numberTaskDone ?? 0) /
                                (category?.numberTask ?? 0);
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: themeColor.drowerBgClor,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, route.categoryPage,
                                          arguments: category);
                                    },
                                    child: ListTile(
                                        leading: Icon(
                                          Icons.check,
                                          size: 30,
                                          color: themeColor.fgColor,
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.delete_outline,
                                            size: 30,
                                            color: themeColor.errorColor,
                                          ),
                                          onPressed: () {
                                            context
                                                .read<CrudCategoryBloc>()
                                                .add(CrudCategoryEvent(
                                                    requestEvent:
                                                        CrudEventStatus.DELETE,
                                                    category: category));
                                            context.read<CategoryBloc>().add(
                                                CategoryEvent(
                                                    requestEvent:
                                                        CrudEventStatus.FETCH));
                                            context.read<TodayBloc>().add(
                                                TodayEvent(
                                                    requestEvent:
                                                        CrudEventStatus.FETCH));
                                          },
                                        ),
                                        title: Row(
                                          children: [
                                            Text(category?.name as String,
                                                style: TextStyle(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.w500,
                                                    color: themeColor.fgColor)),
                                            const Spacer(),
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                size: 30,
                                                color: themeColor.primaryColor,
                                              ),
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    route.addCategoryPage,
                                                    arguments: category);
                                              },
                                            ),
                                          ],
                                        )),
                                  ),
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                );

              default:
                return Container();
            }
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        tooltip: 'Add',
        backgroundColor: themeColor.secondaryColor,
        onPressed: () {
          Navigator.pushNamed(context, route.addCategoryPage);
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
