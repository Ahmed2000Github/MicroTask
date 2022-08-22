import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/login/login_bloc.dart';
import 'package:microtask/blocs/login/login_event.dart';
import 'package:microtask/blocs/login/signup_bloc.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/services/validation_services.dart';
import 'package:microtask/widgets/custom_clipper.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Signup1Page extends StatefulWidget {
  const Signup1Page({Key? key}) : super(key: key);

  @override
  _Signup1PageState createState() => _Signup1PageState();
}

class _Signup1PageState extends State<Signup1Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic _validationUserMsg;
  dynamic _validationEmailMsg;
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: themeColor.fgColor),
            ),
            Text(AppLocalizations.of(context)?.back ?? '',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: themeColor.fgColor))
          ],
        ),
      ),
    );
  }

  Future validateUsername(String username) async {
    _validationUserMsg = null;
    setState(() {});

    bool isExist = await ValidationServices.checkUser(username);

    if (isExist) {
      _validationUserMsg =
          AppLocalizations.of(context)?.signupV3(username) ?? '';
      setState(() {});
    }
  }

  Future validateEmail(String email) async {
    _validationEmailMsg = null;
    setState(() {});

    bool isExist = await ValidationServices.checkEmail(context, email.trim());

    if (isExist) {
      _validationEmailMsg = AppLocalizations.of(context)?.signupV3(email) ?? '';
      setState(() {});
    }
  }

  Widget _entryField(String title, String placeholder, String inputType,
      TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: themeColor.fgColor),
          ),
          const SizedBox(
            height: 10,
          ),
          Focus(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: themeColor.secondaryColor)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide:
                        BorderSide(color: themeColor.primaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide:
                        BorderSide(color: themeColor.primaryColor, width: 2.0),
                  ),
                  hintText: placeholder,
                  fillColor: themeColor.inputbgColor,
                  filled: true),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)?.signupV1 ?? '';
                }
                switch (inputType) {
                  case "email":
                    if (!ValidationServices.isEmail(value.trim())) {
                      return AppLocalizations.of(context)?.signupV2 ?? '';
                    }
                    return _validationEmailMsg;
                  case "name":
                    break;
                  case "username":
                    return _validationUserMsg;

                  default:
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Row(
      children: [
        const Spacer(),
        TextButton(
          onPressed: () async {
            _validationEmailMsg = null;
            _validationUserMsg = null;

            if (!_formKey.currentState!.validate()) {
              return;
            }
            await validateEmail(emailController.text.trim());
            await validateUsername(usernameController.text.trim());
            if (!_formKey.currentState!.validate()) {
              return;
            }
            final collectedData = {
              'email': emailController.text.trim(),
              'firstName': firstNameController.text.trim(),
              'lastName': lastNameController.text.trim(),
              'username': usernameController.text.trim(),
            };

            ValidationServices.sendVerificationEmail(
                context, emailController.text.trim());
            var result = await showDialog<bool>(
                barrierDismissible: false,
                context: context,
                builder: (context) =>
                    StatefulBuilder(builder: (context, setState) {
                      final GlobalKey<FormState> _formDialogKey =
                          GlobalKey<FormState>();
                      return Form(
                        key: _formDialogKey,
                        child: AlertDialog(
                          backgroundColor: themeColor.bgColor,
                          title: Text(
                              AppLocalizations.of(_scaffoldKey.currentContext!)
                                      ?.signup1DATitle ??
                                  '',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: themeColor.fgColor)),
                          content: Builder(
                            builder: (context) {
                              var height = MediaQuery.of(context).size.height;
                              var width = MediaQuery.of(context).size.width;

                              return Container(
                                height: height * .1,
                                width: width * .9,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: themeColor.fgColor,
                                        fontSize: 20),
                                    controller: codeController,
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            borderSide: BorderSide(
                                                color:
                                                    themeColor.secondaryColor)),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                              color: themeColor.primaryColor,
                                              width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                              color: themeColor.primaryColor,
                                              width: 2.0),
                                        ),
                                        labelStyle: TextStyle(
                                            color: themeColor.fgColor
                                                .withOpacity(.6)),
                                        floatingLabelAlignment:
                                            FloatingLabelAlignment.start,
                                        hintStyle: TextStyle(
                                            color: themeColor.fgColor
                                                .withOpacity(.5),
                                            fontSize: 20),
                                        labelText: AppLocalizations.of(
                                                    _scaffoldKey
                                                        .currentContext!)
                                                ?.signup1DAKey ??
                                            '',
                                        hintText:
                                            AppLocalizations.of(_scaffoldKey.currentContext!)
                                                    ?.signup1DAKeyP ??
                                                '',
                                        // fillColor: themeColor.inputbgColor,
                                        filled: true),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value?.isEmpty as bool) {
                                        return AppLocalizations.of(_scaffoldKey
                                                    .currentContext!)
                                                ?.signup1DAKeyV1 ??
                                            '';
                                      }
                                      if (value != ValidationServices.code) {
                                        return AppLocalizations.of(_scaffoldKey
                                                    .currentContext!)
                                                ?.signup1DAKeyV2 ??
                                            '';
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                AppLocalizations.of(
                                            _scaffoldKey.currentContext!)
                                        ?.cancel ??
                                    '',
                                style: TextStyle(color: themeColor.errorColor),
                              ),
                              onPressed: () {
                                ValidationServices.code = "";
                                Navigator.pop(context, false);
                              },
                            ),
                            TextButton(
                              child: Text(AppLocalizations.of(
                                          _scaffoldKey.currentContext!)
                                      ?.ok ??
                                  ''),
                              onPressed: () {
                                if (!_formDialogKey.currentState!.validate()) {
                                  return;
                                }
                                Navigator.pop(context, true);
                              },
                            ),
                          ],
                        ),
                      );
                    }));
            if (result as bool) {
              Navigator.pushNamed(context, route.signup2Page,
                  arguments: collectedData);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * .5,
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(5)),
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      themeColor.inputbgColor,
                      themeColor.primaryColor
                    ])),
            child: Text(
              AppLocalizations.of(context)?.next ?? '',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)?.alreadyHaveAccount ?? '',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: themeColor.fgColor),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              context
                  .read<SingupBloc>()
                  .add(LoginEvent(requestEvent: LoginEventStatus.NONE));
              Navigator.pushNamed(context, route.loginPage);
            },
            child: Text(
              AppLocalizations.of(context)?.login ?? '',
              style: TextStyle(
                  color: themeColor.secondaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputWidget() {
    return Column(
      children: <Widget>[
        _entryField(
            AppLocalizations.of(context)?.signupEmail ?? '',
            AppLocalizations.of(context)?.signupEmailP ?? '',
            'email',
            emailController),
        _entryField(
            AppLocalizations.of(context)?.signupFirstName ?? '',
            AppLocalizations.of(context)?.signupFirstNameP ?? '',
            'name',
            firstNameController),
        _entryField(
            AppLocalizations.of(context)?.signupLastName ?? '',
            AppLocalizations.of(context)?.signupLastNameP ?? '',
            'name',
            lastNameController),
        _entryField(
            AppLocalizations.of(context)?.signupUsername ?? '',
            AppLocalizations.of(context)?.signupUsernameP ?? '',
            "username",
            usernameController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          color: themeColor.bgColor,
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -width * .4,
                  child: const BezierContainer()),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .23),
                        Image.asset(
                          "assets/images/microtask_" +
                              (themeColor.isDarkMod ? "dark" : "light") +
                              ".png",
                          width: width * .4,
                        ),
                        const SizedBox(height: 40),
                        _inputWidget(),
                        const SizedBox(height: 20),
                        _submitButton(),
                        // _divider(),
                        // SizedBox(height: height * .002),
                        _loginLabel(),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    codeController.dispose();
  }
}
