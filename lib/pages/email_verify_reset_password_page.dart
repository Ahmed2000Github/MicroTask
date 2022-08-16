import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/services/validation_services.dart';
import 'package:microtask/widgets/custom_clipper.dart';
import 'package:microtask/configurations/route.dart' as route;

class EmailVerificationPage extends StatefulWidget {
  EmailVerificationPage({Key? key}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic _validationEmailMsg;
  TextEditingController emailController = TextEditingController();
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

  Future validateEmail(String email) async {
    _validationEmailMsg = null;
    setState(() {});

    bool isExist = await ValidationServices.checkEmail(email);

    if (!isExist) {
      _validationEmailMsg = "${email} not exist";
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
                      if (!ValidationServices.isEmail(value)) {
                        return 'The value is not email.';
                      }
                      return _validationEmailMsg;

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
            if (!_formKey.currentState!.validate()) {
              return;
            }
            await validateEmail(emailController.text.trim());

            if (!_formKey.currentState!.validate()) {
              return;
            }
            final collectedData = {
              'email': emailController.text,
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
                                        hintText:
                                            "code .... ahmedelrhaouti2000@gmail.com",
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
                                Navigator.pushNamed(
                                    context, route.resetPasswordPage,
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

  Widget _inputWidget() {
    return Column(
      children: <Widget>[
        _entryField(
            "Enter the email :", "Example@gmail.com", 'email', emailController),
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

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    codeController.dispose();
  }
}
