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

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic _validationEmailMsg;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        exit(0);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: themeColor.fgColor),
            ),
            Text('Back',
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
        margin: EdgeInsets.symmetric(vertical: 10),
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

            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  enabledBorder: OutlineInputBorder(),
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
                  return 'The value of this input should not be empty.';
                }
                switch (inputType) {
                  case "email":
                    if (!ValidationServices.isEmail(value)) {
                      return 'The value is not email.';
                    }
                    return _validationEmailMsg;
                  case "password":
                    return ValidationServices.isValidPassword(value);

                  default:
                }
              },
            ),
          ],
        ),
      );
    });
  }

  Future validateEmail(String email) async {
    _validationEmailMsg = null;
    setState(() {});

    bool isExist = await ValidationServices.checkEmail(email);

    if (!isExist) {
      _validationEmailMsg = "${email} not exist";
      setState(() {});
    }
  }

  Widget _submitButton() {
    return TextButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        await validateEmail(emailController.text);

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
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [themeColor.inputbgColor, themeColor.primaryColor])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: themeColor.fgColor),
          ),
          SizedBox(
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
              'Register',
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
          return Container(
            height: MediaQuery.of(context).size.height * .4,
            child: Center(
                child: SpinKitSpinningLines(
                    lineWidth: 5, color: themeColor.primaryColor)),
          );
        case StateStatus.ERROR:
          return Column(
            children: <Widget>[
              _entryField("Enter the Email or Username :",
                  "Email or Username ...", 'emial',
                  controller: emailController),
              _entryField("Enter the password :", "Password ...", 'password',
                  isPassword: true, controller: passwordController),
              Text(
                state.errorMessage.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: themeColor.errorColor),
              ),
            ],
          );
        case StateStatus.LOADED:
          _goToHomePage();
          return Container(
            height: MediaQuery.of(context).size.height * .4,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitSpinningLines(
                      lineWidth: 5, color: themeColor.primaryColor),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Your login was completed successfully. ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: themeColor.secondaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'waiting for redirection.',
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
          _entryField(
              "Enter the Email or Username :", "Email or Username ...", 'email',
              controller: emailController),
          _entryField("Enter the password :", "Password ...", 'password',
              isPassword: true, controller: passwordController),
          Text(
            "",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: themeColor.errorColor),
          ),
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
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                      SizedBox(height: 50),
                      _inputWidget(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            context.read<LoginBloc>().add(LoginEvent(
                                requestEvent: LoginEventStatus.NONE));
                            Navigator.pushNamed(
                                context, route.emailVerificationPage);
                          },
                          child: Text('Forgot Password ?',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: themeColor.secondaryColor)),
                        ),
                      ),
                      SizedBox(height: 20),
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


// abdelatif.azdoud@adria-bt.com
    // Abdelatif98
