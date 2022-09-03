import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/login/login_bloc.dart';
import 'package:microtask/blocs/login/login_event.dart';
import 'package:microtask/blocs/login/login_state.dart';
import 'package:microtask/blocs/login/rest_password_bloc.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/services/validation_services.dart';
import 'package:microtask/widgets/custom_clipper.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/widgets/custom_snakbar_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      TextEditingController controller,
      {bool isPassword = true}) {
    return StatefulBuilder(builder: (context, setInnerState) {
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
                obscureText: isPassword,
                controller: controller,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        borderSide:
                            BorderSide(color: themeColor.secondaryColor)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                          color: themeColor.primaryColor, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                          color: themeColor.primaryColor, width: 2.0),
                    ),
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
                    return AppLocalizations.of(context)?.resetV1 ?? '';
                  }
                  switch (inputType) {
                    case "comfirm":
                      if (passwordController.text != value) {
                        return AppLocalizations.of(context)?.resetV2 ?? '';
                      }
                      return null;
                    case "password":
                      return ValidationServices.isValidPassword(context, value);

                    default:
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _submitButton() {
    return Row(
      children: [
        const Spacer(),
        TextButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            final collectedData = {
              'email': widget.colletedData['email'],
              'password': passwordController.text,
            };
            context.read<ResetPasswordBloc>().add(LoginEvent(
                requestEvent: LoginEventStatus.RESETPASSWORD,
                data: collectedData));
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
              AppLocalizations.of(context)?.reset ?? '',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputWidget() {
    return BlocBuilder<ResetPasswordBloc, LoginState>(
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

          case StateStatus.ERROR:
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              CustomSnakbarWidget(
                      context: context, color: themeColor.errorColor)
                  .show(state.errorMessage!);
              context
                  .read<ResetPasswordBloc>()
                  .add(LoginEvent(requestEvent: LoginEventStatus.NONE));
            });
            break;
          default:
        }
        return Column(
          children: <Widget>[
            _entryField(
                AppLocalizations.of(context)?.resetNewPassword ?? '',
                AppLocalizations.of(context)?.resetNewPasswordP ?? '',
                'password',
                passwordController),
            _entryField(
                AppLocalizations.of(context)?.resetConfirmPassword ?? '',
                AppLocalizations.of(context)?.resetConfirmPasswordP ?? '',
                'comfirm',
                passwordConfirmController),
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
    context
        .read<ResetPasswordBloc>()
        .add(LoginEvent(requestEvent: LoginEventStatus.NONE));
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
