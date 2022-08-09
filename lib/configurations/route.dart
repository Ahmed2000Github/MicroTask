import 'package:flutter/material.dart';
import 'package:microtask/pages/email_verify_reset_password_page.dart';
import 'package:microtask/pages/main_page.dart';
import 'package:microtask/pages/login_page.dart';
import 'package:microtask/pages/reset_password_page.dart';
import 'package:microtask/pages/signup1_page.dart';
import 'package:microtask/pages/signup2_page.dart';
import 'package:microtask/pages/task_page.dart';

const String loginPage = 'login';
const String signup1Page = 'signup1';
const String signup2Page = 'signup2';
const String mainPage = 'main';
// const String profilePage = 'profile';
// const String settingsPage = 'settings';
// const String homePage = 'home';
const String taskPage = 'task';
const String emailVerificationPage = 'VerifyEmail';
const String resetPasswordPage = 'resetPassword';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case loginPage:
      return MaterialPageRoute(builder: ((context) => LoginPage()));
    case signup1Page:
      return MaterialPageRoute(builder: ((context) => Signup1Page()));
    case signup2Page:
      return MaterialPageRoute(
          builder: ((context) => Signup2Page(
                colletedData: settings.arguments as Map<String, dynamic>,
              )));
    case mainPage:
      return MaterialPageRoute(builder: ((context) => MainPage()));
    case emailVerificationPage:
      return MaterialPageRoute(builder: ((context) => EmailVerificationPage()));
    case resetPasswordPage:
      return MaterialPageRoute(
          builder: ((context) => ResetPasswordPage(
                colletedData: settings.arguments as Map<String, dynamic>,
              )));
    case taskPage:
      return MaterialPageRoute(builder: ((context) => TaskPage()));
    default:
      throw ('This route name does not exist!');
  }
}
