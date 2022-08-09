import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/date/date_bloc.dart';
import 'package:microtask/blocs/home/home_bloc.dart';
import 'package:microtask/blocs/login/login_bloc.dart';
import 'package:microtask/blocs/profile/profile_bloc.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/services/login_services.dart';
import 'package:microtask/configurations/route.dart' as route;

void setUp() {
  GetIt.I.registerLazySingleton(() => ThemeColor());
  GetIt.I.registerLazySingleton(() => LoginServices());
}

Future<void> main() async {
  setUp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
