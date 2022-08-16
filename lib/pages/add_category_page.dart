import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/crud_category/crud_category_bloc.dart';
import 'package:microtask/blocs/crud_category/crud_category_event.dart';
import 'package:microtask/blocs/crud_category/crud_category_state.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/custom_snakbar_widget.dart';

class AddCategoryPage extends StatefulWidget {
  Category? category;

  AddCategoryPage({this.category});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  TextEditingController nameController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.category?.name as String;
    descriptionController.text = widget.category?.description as String;
    context
        .read<CrudCategoryBloc>()
        .add(CrudCategoryEvent(requestEvent: CrudEventStatus.RESET));
  }

  //  {
  Widget _titleField() {
    return TextFormField(
      style: TextStyle(color: themeColor.fgColor, fontSize: 20),
      controller: nameController,
      decoration: InputDecoration(
          labelText: 'Enter the name',
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
          hintText: "Name ...",
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
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
          hintText: "Description ...",
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeColor.bgColor,
      body: Container(
        child: Center(
            child: Column(
          children: [
            const SizedBox(
              height: 12,
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
                  Spacer(),
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
              child: ListView(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                            (widget.category == null ? 'Create' : 'Update') +
                                ' Category',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: themeColor.fgColor)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            (widget.category == null
                                    ? 'Create new'
                                    : 'Update exist') +
                                ' Category',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: themeColor.fgColor)),
                      ],
                    ),
                  ),
                  Container(
                      height: height * .8,
                      // color: themeColor.errorColor,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child:
                              BlocBuilder<CrudCategoryBloc, CrudCategoryState>(
                                  builder: (context, state) {
                            switch (state.requestState) {
                              case StateStatus.LOADED:
                                WidgetsBinding.instance
                                    ?.addPostFrameCallback((_) {
                                  Navigator.pop(context);
                                });
                                WidgetsBinding.instance
                                    ?.addPostFrameCallback((_) {
                                  setState(() {
                                    widget.category = null;
                                  });
                                });
                                context.read<CategoryBloc>().add(CategoryEvent(
                                    requestEvent: CrudEventStatus.FETCH));
                                context.read<CrudCategoryBloc>().add(
                                    CrudCategoryEvent(
                                        requestEvent: CrudEventStatus.RESET));

                                return Container();
                              case StateStatus.LOADING:
                                return CustomLoadingProgress(
                                    color: themeColor.primaryColor,
                                    height: height * .8);
                              case StateStatus.ERROR:
                                WidgetsBinding.instance
                                    ?.addPostFrameCallback((_) {
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
                                    _titleField(),
                                    SizedBox(
                                      height: height * .08,
                                    ),
                                    _descriptionField(),
                                    SizedBox(
                                      height: height * .08,
                                    ),
                                    GestureDetector(
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
                                            (widget.category == null
                                                ? 'create'
                                                : 'Update'),
                                            style: TextStyle(
                                                letterSpacing: 2,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                                color: themeColor.fgColor)),
                                      ),
                                    )
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
        )),
      ),
    );
  }

  void handleRequest() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final _category = Category(
        name: nameController.text, description: descriptionController.text);
    nameController.clear();
    descriptionController.clear();
    if (widget.category == null) {
      context.read<CrudCategoryBloc>().add(CrudCategoryEvent(
          requestEvent: CrudEventStatus.ADD, category: _category));
    } else {
      _category.id = widget.category?.id;
      context.read<CrudCategoryBloc>().add(CrudCategoryEvent(
          requestEvent: CrudEventStatus.EDIT, category: _category));
    }
  }
}
