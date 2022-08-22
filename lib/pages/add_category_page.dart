import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/crud_category/crud_category_bloc.dart';
import 'package:microtask/blocs/crud_category/crud_category_event.dart';
import 'package:microtask/blocs/crud_category/crud_category_state.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/widgets/custom_appbar_widget.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/custom_snakbar_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();
  final GlobalKey _first = GlobalKey();
  final GlobalKey _second = GlobalKey();
  final GlobalKey _thirth = GlobalKey();
  @override
  void initState() {
    super.initState();
    nameController.text = widget.category?.name as String;
    descriptionController.text = widget.category?.description as String;
    context
        .read<CrudCategoryBloc>()
        .add(CrudCategoryEvent(requestEvent: CrudEventStatus.RESET));
    if (showCaseConfig.isLunched(route.addCategoryPage)) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(Duration(seconds: 1)).then((value) =>
            ShowCaseWidget.of(context)
                .startShowCase([_first, _second, _thirth])),
      );
    }
  }

  //  {
  Widget _titleField() {
    return TextFormField(
      style: TextStyle(color: themeColor.fgColor, fontSize: 20),
      controller: nameController,
      decoration: InputDecoration(
          labelText: AppLocalizations.of(context)?.addCategoryName ?? '',
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
          hintText: AppLocalizations.of(context)?.addCategoryNameP ?? '',
          // fillColor: themeColor.inputbgColor,
          filled: true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value?.isEmpty as bool) {
          return AppLocalizations.of(context)?.addCategoryNameV1 ?? '';
        }
        if (value?.length as int > 12) {
          return AppLocalizations.of(context)?.addCategoryNameV2 ?? '';
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
          labelText: AppLocalizations.of(context)?.addCategoryDescription ?? '',
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
          hintText: AppLocalizations.of(context)?.addCategoryDescriptionP ?? '',
          // fillColor: themeColor.inputbgColor,
          filled: true),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value?.isEmpty as bool) {
          return AppLocalizations.of(context)?.addCategoryDescriptionV1 ?? '';
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
        child: Center(
            child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            CustomAppBar(
              title: '',
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                            (widget.category == null
                                    ? AppLocalizations.of(context)?.create ?? ''
                                    : AppLocalizations.of(context)?.update ??
                                        '') +
                                (AppLocalizations.of(context)?.category ?? ''),
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: themeColor.fgColor)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            (widget.category == null
                                ? AppLocalizations.of(context)?.createNew ?? ''
                                : AppLocalizations.of(context)?.updateExist ??
                                    ''),
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
                                    Showcase(
                                        key: _first,
                                        description:
                                            AppLocalizations.of(context)
                                                    ?.addCategoryd1 ??
                                                '',
                                        child: _titleField()),
                                    SizedBox(
                                      height: height * .08,
                                    ),
                                    Showcase(
                                        key: _second,
                                        description:
                                            AppLocalizations.of(context)
                                                    ?.addCategoryd2 ??
                                                '',
                                        child: _descriptionField()),
                                    SizedBox(
                                      height: height * .08,
                                    ),
                                    GestureDetector(
                                      onTap: handleRequest,
                                      child: Showcase(
                                        key: _thirth,
                                        description:
                                            AppLocalizations.of(context)
                                                    ?.addCategoryd3 ??
                                                '',
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
                                                  ? AppLocalizations.of(context)
                                                          ?.create ??
                                                      ''
                                                  : AppLocalizations.of(context)
                                                          ?.update ??
                                                      ''),
                                              style: TextStyle(
                                                  letterSpacing: 2,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                  color: themeColor.fgColor)),
                                        ),
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
