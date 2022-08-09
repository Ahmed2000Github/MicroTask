import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/login/login_bloc.dart';
import 'package:microtask/blocs/login/login_event.dart';
import 'package:microtask/blocs/login/login_state.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/services/validation_services.dart';
import 'package:microtask/widgets/custom_clipper.dart';
import 'package:microtask/configurations/route.dart' as route;

class ResetPasswordPage extends StatefulWidget {
  Map<String, dynamic> colletedData;
  ResetPasswordPage({Key? key, required this.colletedData}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
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
      TextEditingController controller,
      {bool isPassword = true}) {
    return StatefulBuilder(builder: (context, setInnerState) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
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
            SizedBox(
              height: 10,
            ),
            Focus(
                child: TextFormField(
                  obscureText: isPassword,
                  controller: controller,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      hintText: placeholder,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setInnerState(() => isPassword = !isPassword),
                      ),
                      fillColor: themeColor.inputbgColor,
                      filled: true),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'The value of this input should not be empty.';
                    }
                    switch (inputType) {
                      case "comfirm":
                        if (passwordController.text != value) {
                          return "Password not matched";
                        }
                        return null;
                      case "password":
                        return ValidationServices.isValidPassword(value);

                      default:
                    }
                    return null;
                  },
                ),
                onFocusChange: (hasFocus) {
                  // switch (inputType) {
                  //   case 'username':
                  //     if (!hasFocus) validateUsername(usernameController.text);
                  //     break;
                  //   case 'email':
                  //     if (!hasFocus) validateEmail(passwordController.text);
                  //     break;
                  //   default:
                  // }
                }),
          ],
        ),
      );
    });
  }

  Widget _submitButton() {
    return Row(
      children: [
        Spacer(),
        TextButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            final collectedData = {
              'email': widget.colletedData['email'],
              'password': passwordController.text,
            };
            context.read<LoginBloc>().add(LoginEvent(
                requestEvent: LoginEventStatus.RESETPASSWORD,
                data: collectedData));
          },
          child: Container(
            width: MediaQuery.of(context).size.width * .5,
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      themeColor.inputbgColor,
                      themeColor.primaryColor
                    ])),
            child: Text(
              'Reset',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputWidget() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        switch (state.requestState) {
          case StateStatus.LOADING:
            return Container(
              height: MediaQuery.of(context).size.height * .4,
              child: Center(
                  child: SpinKitSpinningLines(
                      lineWidth: 5, color: themeColor.primaryColor)),
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

          case StateStatus.ERROR:
            return Column(
              children: <Widget>[
                _entryField("Enter the new password :", "Password ... ",
                    'password', passwordController),
                _entryField("Comfirm the new password :", "Password ... ",
                    'comfirm', passwordConfirmController),
                Text(
                  state.errorMessage.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: themeColor.errorColor),
                )
              ],
            );
          default:
        }
        return Column(
          children: <Widget>[
            _entryField("Enter the new password :", "Password ... ", 'password',
                passwordController),
            _entryField("Comfirm the new password :", "Password ... ",
                'comfirm', passwordConfirmController),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      color: themeColor.bgColor,
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15, right: -width * .4, child: BezierContainer()),
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
                    SizedBox(height: MediaQuery.of(context).size.height * .2),
                    _inputWidget(),
                    SizedBox(height: MediaQuery.of(context).size.height * .05),
                    _submitButton(),
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

  void _goToHomePage() {
    Future.delayed(const Duration(microseconds: 400), () {
      Navigator.pushNamed(context, route.mainPage);
    });
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
  }
}
