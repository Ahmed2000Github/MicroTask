import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/login/login_bloc.dart';
import 'package:microtask/blocs/login/login_event.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/services/validation_services.dart';
import 'package:microtask/widgets/custom_clipper.dart';
import 'package:microtask/configurations/route.dart' as route;

class Signup1Page extends StatefulWidget {
  const Signup1Page({Key? key}) : super(key: key);

  @override
  _Signup1PageState createState() => _Signup1PageState();
}

class _Signup1PageState extends State<Signup1Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  Future validateUsername(String username) async {
    _validationUserMsg = null;
    setState(() {});

    bool isExist = await ValidationServices.checkUser(username);

    if (isExist) {
      _validationUserMsg = "${username} already taken";
      setState(() {});
    }
  }

  Future validateEmail(String email) async {
    _validationEmailMsg = null;
    setState(() {});

    bool isExist = await ValidationServices.checkEmail(email);

    if (isExist) {
      _validationEmailMsg = "${email} already taken";
      setState(() {});
    }
  }

  Widget _entryField(String title, String placeholder, String inputType,
      TextEditingController controller) {
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
                controller: controller,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
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
                      if (!ValidationServices.isEmail(value.trim())) {
                        return 'The value is not email.';
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
              onFocusChange: (hasFocus) {
                // switch (inputType) {
                //   case 'username':
                //     if (!hasFocus) validateUsername(usernameController.text);
                //     break;
                //   case 'email':
                //     if (!hasFocus) validateEmail(emailController.text);
                //     break;
                //   default:
                // }
              }),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Row(
      children: [
        Spacer(),
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
                emailController.text.trim());
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) =>
                    StatefulBuilder(builder: (context, setState) {
                      final GlobalKey<FormState> _formDialogKey =
                          GlobalKey<FormState>();

                      print("object  ");
                      return Form(
                        key: _formDialogKey,
                        child: AlertDialog(
                          backgroundColor: themeColor.bgColor,
                          title: Text("Enter the code sended to your mail.",
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
                                    controller: codeController,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        hintText: "code ....",
                                        fillColor: themeColor.inputbgColor,
                                        filled: true),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == ValidationServices.code) {
                                        return null;
                                      } else {
                                        return "The selected code is not correct";
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
                                "Cancel",
                                style: TextStyle(color: themeColor.errorColor),
                              ),
                              onPressed: () {
                                ValidationServices.code = "";
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                if (!_formDialogKey.currentState!.validate()) {
                                  return;
                                }
                                print("valid  ");
                                Navigator.pop(context);
                                Navigator.pushNamed(context, route.signup2Page,
                                    arguments: collectedData);
                              },
                            ),
                          ],
                        ),
                      );
                    }));
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
              'Next',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _loginLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ',
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
              Navigator.pushNamed(context, route.loginPage);
            },
            child: Text(
              'Login',
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
        _entryField("Enter your email :", "Example@gmail.com", 'email',
            emailController),
        _entryField("Enter your first name :", "First name ...", 'name',
            firstNameController),
        _entryField("Enter your last name :", "Last name ...", 'name',
            lastNameController),
        _entryField("Enter the username :", "Username ...", "username",
            usernameController),
        Text(
          "",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: themeColor.errorColor),
        ),
      ],
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
                    SizedBox(height: 40),
                    _inputWidget(),
                    SizedBox(height: 20),
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
