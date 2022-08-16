import 'package:flutter/material.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/pages/about_page.dart';
import 'package:microtask/pages/add_category_page.dart';
import 'package:microtask/pages/add_task_page.dart';
import 'package:microtask/pages/categories_page.dart';
import 'package:microtask/pages/category_page.dart';
import 'package:microtask/pages/email_verify_reset_password_page.dart';
import 'package:microtask/pages/main_page.dart';
import 'package:microtask/pages/login_page.dart';
import 'package:microtask/pages/notification_page.dart';
import 'package:microtask/pages/reminder_page.dart';
import 'package:microtask/pages/reset_password_page.dart';
import 'package:microtask/pages/signup1_page.dart';
import 'package:microtask/pages/signup2_page.dart';
import 'package:microtask/pages/task_page.dart';
import 'package:microtask/pages/today_task_page.dart';
import 'package:showcaseview/showcaseview.dart';

const String loginPage = 'login';
const String signup1Page = 'signup1';
const String signup2Page = 'signup2';
const String mainPage = 'main';
// const String profilePage = 'profile';
// const String settingsPage = 'settings';
// const String homePage = 'home';
const String taskPage = 'task';
const String aboutPage = 'about';
const String todayPage = 'today';
const String addTaskPage = 'addTask';
const String reminderPage = 'reminder';
const String notificationPage = 'notification';
const String categoryPage = 'category';
const String addCategoryPage = 'addCategory';
const String categoriesPage = 'categories';
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
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TaskPage(
          categoryId: settings.arguments as String,
        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    case reminderPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ReminderPage(),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeIn;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    case categoryPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CategoryPage(
          category: settings.arguments as Category,
        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0);
          const end = Offset.zero;
          const curve = Curves.easeIn;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    case categoriesPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CategoriesPage(),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1);
          const end = Offset.zero;
          const curve = Curves.easeIn;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    case addCategoryPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddCategoryPage(
          category: settings.arguments as Category,
        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1);
          const end = Offset.zero;
          const curve = Curves.easeIn;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    case addTaskPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddTaskPage(
          data: settings.arguments as Map<String, dynamic>,
        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1);
          const end = Offset.zero;
          const curve = Curves.easeIn;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    case notificationPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            NotificationPage(
          taskId: settings.arguments as String,
        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1);
          const end = Offset.zero;
          const curve = Curves.easeIn;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    case todayPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TodayPage(),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.easeIn;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    case aboutPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return AboutPage();
          }),
        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 1);
          const end = Offset.zero;
          const curve = Curves.easeIn;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    default:
      throw ('This route name does not exist!');
  }
}
