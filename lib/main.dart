import 'dart:ui';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:microtask/blocs/category/category_bloc.dart';
import 'package:microtask/blocs/category/category_cubit.dart';
import 'package:microtask/blocs/crud_category/crud_category_bloc.dart';
import 'package:microtask/blocs/crud_task/crud_task_bloc.dart';
import 'package:microtask/blocs/date/date_bloc.dart';
import 'package:microtask/blocs/home/home_bloc.dart';
import 'package:microtask/blocs/lang/lang_cubit.dart';
import 'package:microtask/blocs/login/login_bloc.dart';
import 'package:microtask/blocs/login/rest_password_bloc.dart';
import 'package:microtask/blocs/login/signup_bloc.dart';
import 'package:microtask/blocs/logout/logout_bloc.dart';
import 'package:microtask/blocs/note/note_crud_bloc.dart';
import 'package:microtask/blocs/note/note_cubit.dart';
import 'package:microtask/blocs/note/note_date_cubit.dart';
import 'package:microtask/blocs/note/one_note_cubit.dart';
import 'package:microtask/blocs/profile/profile_bloc.dart';
import 'package:microtask/blocs/reminder/reminder_bloc.dart';
import 'package:microtask/blocs/synchronization/synch_bloc.dart';
import 'package:microtask/blocs/task/task_bloc.dart';
import 'package:microtask/blocs/task/task_cubit.dart';
import 'package:microtask/blocs/today/today_bloc.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/enums/gender_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/models/note_model.dart';
import 'package:microtask/models/profile_model.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/services/category_services.dart';
import 'package:microtask/services/excepion_handler_services.dart';
import 'package:microtask/services/login_services.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/services/note_services.dart';
import 'package:microtask/services/notification_service.dart';
import 'package:microtask/services/sync_services.dart';
import 'package:microtask/services/task_services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void setUp(Locale locale) {
  GetIt.I.registerLazySingleton(() => ThemeColor());
  GetIt.I.registerLazySingleton(() => LoginServices());
  GetIt.I.registerLazySingleton(() => TaskServices());
  GetIt.I.registerLazySingleton(() => CategoryServices());
  GetIt.I.registerLazySingleton(() => NotificationServices());
  GetIt.I.registerLazySingleton(() => Configuration(locale));
  GetIt.I.registerLazySingleton(() => SyncServices());
  GetIt.I.registerLazySingleton(() => ShowCaseConfig());
  GetIt.I.registerLazySingleton(() => ExceptionHandler());
  GetIt.I.registerLazySingleton(() => Noteservices());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> init() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
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
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(RepeatTypeAdapter());
  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(GenderAdapter());
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox('colorsBox');
  await Hive.openBox('configurationsBox');
  await Hive.openBox('showCaseBox');
  await Hive.openBox('tasksBox');
  await Hive.openBox('fontsBox');
  await Hive.openBox('categoriesBox');
  await Hive.openBox('profileBox');
  await Hive.openBox('noteBox');
}

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final preferred = widgetsBinding.window.locales;
  const supported = AppLocalizations.supportedLocales;
  final locale = basicLocaleListResolution(preferred, supported);
  setUp(locale);
  await Firebase.initializeApp();
  await initializeHiveBoxes();
  // await initializeDateFormatting();
  init();
  runApp(Splash());
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen.withScreenFunction(
        duration: 200,
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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user = FirebaseAuth.instance.currentUser;

  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  Configuration get configuration => GetIt.I<Configuration>();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => SingupBloc(),
        ),
        BlocProvider(
          create: (context) => ResetPasswordBloc(),
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
        BlocProvider(
          create: (context) => SyncBloc(),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(),
        ),
        BlocProvider(
          create: (context) => NoteCubit(),
        ),
        BlocProvider(
          create: (context) => NoteDateCubit(),
        ),
        BlocProvider(
          create: (context) => OneNoteCubit(),
        ),
        BlocProvider(
          create: (context) => TaskCubit(),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(),
        ),
        BlocProvider(
          create: (context) => CrudNoteBloc(),
        ),
        BlocProvider(
          create: (context) =>
              LangCubit(Locale(configuration.currentLang ?? 'sys')),
        ),
      ],
      child: BlocBuilder<LangCubit, Locale>(builder: (context, locale) {
        return MaterialApp(
          localeListResolutionCallback: (locales, supportedLocales) {
            window.onLocaleChanged = () {
              context.read<LangCubit>().changeLang();
            };
            var _locale = configuration.getLocale(locale.languageCode);
            configuration.initiateListe(_locale);
            return _locale;
          },
          locale: locale,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'MicroTask',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            unselectedWidgetColor: themeColor.fgColor,
          ),
          onGenerateRoute: route.controller,
          initialRoute: _getInitialRoute(context),
        );
      }),
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
