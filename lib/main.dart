import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/crud_category/crud_category_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/date/date_bloc.dart';
import 'package:microtask/blocs/home/home_bloc.dart';
import 'package:microtask/blocs/login/login_bloc.dart';
import 'package:microtask/blocs/profile/profile_bloc.dart';
import 'package:microtask/blocs/reminder/reminder_bloc.dart';
import 'package:microtask/blocs/task/task_bloc.dart';
import 'package:microtask/blocs/today/today_bloc.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/services/category_services.dart';
import 'package:microtask/services/login_services.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/services/notification_service.dart';
import 'package:microtask/services/task_services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:page_transition/page_transition.dart';

void setUp() {
  GetIt.I.registerLazySingleton(() => ThemeColor());
  GetIt.I.registerLazySingleton(() => LoginServices());
  GetIt.I.registerLazySingleton(() => TaskServices());
  GetIt.I.registerLazySingleton(() => CategoryServices());
  GetIt.I.registerLazySingleton(() => NotificationServices());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> init() async {
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: null,
  );
  tz.initializeTimeZones();
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

Future<void> initializeHiveBoxes() async {
  await Hive.initFlutter();
  await Hive.openBox('colorsBox');
  Hive.registerAdapter(CategoryAdapter());
  await Hive.openBox('categoriesBox');
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(RepeatTypeAdapter());
  await Hive.openBox('tasksBox');
}

Future<void> main() async {
  setUp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeHiveBoxes();
  init();
  runApp(Splash());
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen.withScreenFunction(
        splashIconSize: 200,
        backgroundColor: Colors.blue,
        splash: 'assets/images/microtask_logo.png',
        screenFunction: () async {
          return MyApp();
        },
        curve: Curves.bounceIn,
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.fade,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider(
          create: (context) => DateBloc(),
        ),
        BlocProvider(
          create: (context) => ReminderBloc(),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider(
          create: (context) => CrudCategoryBloc(),
        ),
        BlocProvider(
          create: (context) => CrudTaskBloc(),
        ),
        BlocProvider(
          create: (context) => TaskBloc(),
        ),
        BlocProvider(
          create: (context) => TodayBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MicroTask',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          unselectedWidgetColor: themeColor.fgColor,
        ),
        onGenerateRoute: route.controller,
        initialRoute: _getInitialRoute(context),
      ),
    );
  }

  _getInitialRoute(BuildContext context) {
    if (user == null) {
      return route.loginPage;
    } else {
      return route.mainPage;
    }
    // });
  }
}
