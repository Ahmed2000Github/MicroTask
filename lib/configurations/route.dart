import 'package:flutter/material.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/models/note_model.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/pages/about_page.dart';
import 'package:microtask/pages/add_category_page.dart';
import 'package:microtask/pages/add_note_page.dart';
import 'package:microtask/pages/add_task_page.dart';
import 'package:microtask/pages/categories_page.dart';
import 'package:microtask/pages/category_page.dart';
import 'package:microtask/pages/email_verify_reset_password_page.dart';
import 'package:microtask/pages/get_started_page.dart';
import 'package:microtask/pages/main_page.dart';
import 'package:microtask/pages/login_page.dart';
import 'package:microtask/pages/notes_page.dart';
import 'package:microtask/pages/notification_page.dart';
import 'package:microtask/pages/reminder_page.dart';
import 'package:microtask/pages/reset_password_page.dart';
import 'package:microtask/pages/show_note_page.dart';
import 'package:microtask/pages/show_task_page.dart';
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
const String getStartPage = 'getStart';
const String taskPage = 'task';
const String aboutPage = 'about';
const String notesPage = 'notes';
const String addNotePage = 'addNote';
const String notePage = 'note';
const String todayPage = 'today';
const String addTaskPage = 'addTask';
const String showTaskPage = 'showTask';
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
      print('teseseeeses ');
      return MaterialPageRoute(
          builder: ((context) => ResetPasswordPage(
                colletedData: settings.arguments as Map<String, dynamic>,
              )));
    case taskPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return TaskPage(
              categoryId: settings.arguments as String,
            );
          }),
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
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return ReminderPage();
          }),
        ),
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
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return CategoryPage(
              category: settings.arguments as Category,
            );
          }),
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
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return CategoriesPage();
          }),
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
    case addCategoryPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return AddCategoryPage(
              category: settings.arguments as Category,
            );
          }),
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
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return AddTaskPage(
              data: settings.arguments as Map<String, dynamic>,
            );
          }),
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
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return NotificationPage(
              taskId: settings.arguments as String,
            );
          }),
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
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return TodayPage();
          }),
        ),
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
        pageBuilder: (context, animation, secondaryAnimation) => AboutPage(),
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
    case notesPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return NotesPage(
              rotate: settings.arguments as bool,
            );
          }),
        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
      );
    case addNotePage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return AddNotePage(
                data: (settings.arguments as Map<String, dynamic>));
          }),
        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
      );
    case notePage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return NotePage(data: (settings.arguments as Map<String, dynamic>));
          }),
        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
      );
    case showTaskPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
          builder: Builder(builder: (context) {
            return ShowTaskPage(
                data: (settings.arguments as Map<String, dynamic>));
          }),
        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
      );

    case getStartPage:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            GetStartedPage(),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );

    default:
      throw ('This route name does not exist!');
  }
}
