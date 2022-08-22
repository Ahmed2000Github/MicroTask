import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/login/login_bloc.dart';
import 'package:microtask/blocs/login/login_event.dart';
import 'package:microtask/blocs/login/login_state.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/pages/signup1_page.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/pages/signup2_page.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/services/validation_services.dart';
import 'package:microtask/widgets/custom_clipper.dart';
import 'package:microtask/widgets/custom_snakbar_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        exit(0);
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

  Widget _entryField(String title, String placeholder, String inputType,
      {bool isPassword = false, TextEditingController? controller}) {
    return StatefulBuilder(builder: (context, setInnerState) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SizedBox(
            //   height: 20,
            // ),
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
            TextFormField(
              controller: controller,
              obscureText: isPassword,
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
                  suffixIcon: inputType == 'password'
                      ? IconButton(
                          icon: Icon(
                            isPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () =>
                              setInnerState(() => isPassword = !isPassword),
                        )
                      : null,
                  hintText: placeholder,
                  fillColor: themeColor.inputbgColor,
                  filled: true),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)?.loginV1 ?? '';
                }
                switch (inputType) {
                  case "password":
                    return ValidationServices.isValidPassword(context, value);

                  default:
                }
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _submitButton() {
    return TextButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        context.read<LoginBloc>().add(LoginEvent(
                requestEvent: LoginEventStatus.LOGIN,
                data: {
                  'email': emailController.text.trim(),
                  'password': passwordController.text
                }));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [themeColor.inputbgColor, themeColor.primaryColor])),
        child: Text(
          AppLocalizations.of(context)?.login ?? '',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)?.dontHaveAccount ?? '',
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
                  .read<LoginBloc>()
                  .add(LoginEvent(requestEvent: LoginEventStatus.NONE));
              Navigator.pushNamed(context, route.signup1Page);
            },
            child: Text(
              AppLocalizations.of(context)?.register ?? '',
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
    return BlocBuilder<LoginBloc, LoginState>(builder: ((context, state) {
      switch (state.requestState) {
        case StateStatus.LOADING:
          return SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            child: Center(
                child: SpinKitSpinningLines(
                    lineWidth: 5, color: themeColor.primaryColor)),
          );
        case StateStatus.ERROR:
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            CustomSnakbarWidget(context: context, color: themeColor.errorColor)
                .show(state.errorMessage!);
            context
                .read<LoginBloc>()
                .add(LoginEvent(requestEvent: LoginEventStatus.NONE));
          });
          break;
        case StateStatus.LOADED:
          _goToHomePage();
          return SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitSpinningLines(
                      lineWidth: 5, color: themeColor.primaryColor),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppLocalizations.of(context)?.loginCompleted ?? '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: themeColor.secondaryColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)?.waitingForRedirection ?? '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: themeColor.secondaryColor),
                  ),
                ],
              ),
            ),
          );

        default:
      }
      return Column(
        children: <Widget>[
          _entryField(AppLocalizations.of(context)?.loginEmail ?? '',
              AppLocalizations.of(context)?.loginEmailP ?? '', 'email',
              controller: emailController),
          _entryField(AppLocalizations.of(context)?.loginPassword ?? '',
              AppLocalizations.of(context)?.loginPasswordP ?? '', 'password',
              isPassword: true, controller: passwordController),
        ],
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
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
                      const SizedBox(height: 50),
                      _inputWidget(),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            context.read<LoginBloc>().add(LoginEvent(
                                requestEvent: LoginEventStatus.NONE));
                            Navigator.pushNamed(
                                context, route.emailVerificationPage);
                          },
                          child: Text(
                              AppLocalizations.of(context)?.fogotPassword ?? '',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: themeColor.secondaryColor)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _submitButton(),
                      // _divider(),
                      SizedBox(height: height * .005),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      )),
    );
  }

  void _goToHomePage() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.pushNamed(context, route.mainPage);
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
