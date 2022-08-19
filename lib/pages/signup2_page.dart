import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:microtask/blocs/login/login_bloc.dart';
import 'package:microtask/blocs/login/login_event.dart';
import 'package:microtask/blocs/login/login_state.dart';
import 'package:microtask/blocs/login/signup_bloc.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/gender_enum.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/pages/main_page.dart';
import 'package:microtask/configurations/route.dart' as route;

import 'package:microtask/pages/login_page.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/services/validation_services.dart';
import 'package:microtask/widgets/custom_clipper.dart';

import '../widgets/custom_snakbar_widget.dart';

class Signup2Page extends StatefulWidget {
  Map<String, dynamic> colletedData;
  Signup2Page({Key? key, required this.colletedData}) : super(key: key);

  @override
  _Signup2PageState createState() => _Signup2PageState();
}

class _Signup2PageState extends State<Signup2Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Gender genderController = Gender.MALE;
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  File? image;
  bool isLoaded = false;

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

  DateTime? selectedDate = DateTime(1999);
  Widget _entryField(String title, String placeholder, String inputType,
      TextEditingController controller,
      {bool isPassword = false, Widget? widget}) {
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    readOnly: widget == null ? false : true,
                    obscureText: isPassword,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        hintText: placeholder,
                        suffixIcon: ['password', 'comfirm'].contains(inputType)
                            ? IconButton(
                                icon: Icon(
                                  isPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () => setInnerState(
                                    () => isPassword = !isPassword),
                              )
                            : null,
                        fillColor: themeColor.inputbgColor,
                        filled: true),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'The value of this input should not be empty.';
                      }
                      switch (inputType) {
                        case "password":
                          return ValidationServices.isValidPassword(value);
                        case "date":
                          break;
                        case "comfirm":
                          if (passwordController.text != value) {
                            return "Password not matched";
                          }
                          return null;
                        default:
                      }
                      return null;
                    },
                  ),
                ),
                widget == null ? Container() : widget,
              ],
            ),
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
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            Map<String, dynamic> addedData = {
              'password': passwordController.text,
              'birthDay': dateController.text,
              'gender': genderController,
              'image': image,
              'email': widget.colletedData['email'],
              'username': widget.colletedData['username'],
              'firstName': widget.colletedData['firstName'],
              'lastName': widget.colletedData['lastName'],
              // 'email': "Example@gmail.com",
              // 'username': "username",
              // 'firstName': 'firstName',
              // 'lastName': 'lastName',
            };
            context.read<SingupBloc>().add(LoginEvent(
                requestEvent: LoginEventStatus.REGISTER, data: addedData));
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
              'Finish',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
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
            'Already have an account ?',
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
                  .read<SingupBloc>()
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

  _getSelectedDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime(1999),
        firstDate: DateTime(1950),
        lastDate: DateTime(DateTime.now().year - 10));
    if (date != null) {
      dateController.text = DateFormat("yyyy-MM-dd").format(date);
    }
  }

  Widget _radioField(String title) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: Gender.MALE,
                groupValue: genderController,
                onChanged: (value) {
                  setState(() {
                    genderController = value as Gender;
                  });
                },
                activeColor: themeColor.primaryColor,
              ),
              Text(
                "Male",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: themeColor.fgColor),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .3,
              ),
              Radio(
                value: Gender.FEMALE,
                groupValue: genderController,
                onChanged: (value) {
                  setState(() {
                    genderController = value as Gender;
                  });
                },
                activeColor: themeColor.primaryColor,
              ),
              Text(
                "Female",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: themeColor.fgColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // pick the image
  Future<void> pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? _image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null)
      setState(() {
        image = File(_image.path);
        isLoaded = true;
        // pathOfImage = _image.path;
      });
  }

  Widget _imageField(String title) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: themeColor.primaryColor,
                child: ClipOval(
                    child: isLoaded
                        ? Image.file(
                            image!,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/picture.jpg",
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          )),
              ),
              Spacer(),
              TextButton(
                onPressed: () async {
                  pickImage();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .35,
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
                    'Select',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputWidget() {
    return BlocBuilder<SingupBloc, LoginState>(builder: (context, state) {
      switch (state.requestState) {
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
                    'Your registration was completed successfully. ',
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

        case StateStatus.LOADING:
          return Container(
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
                .read<SingupBloc>()
                .add(LoginEvent(requestEvent: LoginEventStatus.NONE));
          });
          break;
        default:
      }
      return Column(
        children: <Widget>[
          _entryField("Enter your password :", "Password ...", 'password',
              passwordController,
              isPassword: true),
          _entryField("Comfirm the  password :", "Password ... ", 'comfirm',
              passwordConfirmController,
              isPassword: true),
          _entryField(
              "Select your birthDay :",
              DateFormat("yyyy-MM-dd").format(selectedDate!),
              'date',
              dateController,
              widget: IconButton(
                onPressed: () {
                  _getSelectedDate();
                },
                icon: const Icon(Icons.calendar_today_outlined),
                color: themeColor.fgColor,
              )),
          _radioField("Select your Gender :"),
          _imageField("Choose image Profile :"),
          Text(
            "",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: themeColor.errorColor),
          ),
        ],
      );
    });
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

  void _goToHomePage() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.pushNamed(context, route.getStartPage);
    });
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    dateController.dispose();
  }
}
