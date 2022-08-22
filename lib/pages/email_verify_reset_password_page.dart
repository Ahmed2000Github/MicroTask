import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/services/validation_services.dart';
import 'package:microtask/widgets/custom_clipper.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailVerificationPage extends StatefulWidget {
  EmailVerificationPage({Key? key}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  Future validateEmail(String email) async {
    _validationEmailMsg = null;
    setState(() {});

    bool isExist = await ValidationServices.checkEmail(context, email);

    if (!isExist) {
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                    if (!ValidationServices.isEmail(value)) {
                      return AppLocalizations.of(context)?.signupV2 ?? '';
                    }
                    return _validationEmailMsg;

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
                context, emailController.text.trim());

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
                                Navigator.pop(context);
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      themeColor.inputbgColor,
                      themeColor.primaryColor
                    ])),
            child: Text(
              AppLocalizations.of(context)?.next ?? '',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
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
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .2),
                        _inputWidget(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .05),
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
