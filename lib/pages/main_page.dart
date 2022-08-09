import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/home/home_bloc.dart';
import 'package:microtask/blocs/login/login_bloc.dart';
import 'package:microtask/blocs/login/login_event.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/pages/home_page.dart';
import 'package:microtask/pages/profile_page.dart';
import 'package:microtask/pages/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  User? user;
  int currentIndex = 1;

  void setParentState() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    context.read<HomeBloc>().add(HomeEvent.HOME);
    context
        .read<LoginBloc>()
        .add(LoginEvent(requestEvent: LoginEventStatus.NONE));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: themeColor.bgColor,
        drawer: Drawer(
          elevation: 7,
          backgroundColor: themeColor.drowerBgClor,
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        trailing: IconButton(
                          icon: Icon(
                            Icons.arrow_back_outlined,
                            size: 40,
                            color: themeColor.secondaryColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/microtask_" +
                                (themeColor.isDarkMod ? "dark" : "light") +
                                ".png",
                            width: width * .5,
                          ),
                          Text(
                            "MicroTask@gmail.com",
                            style: TextStyle(
                                fontSize: 15, color: themeColor.fgColor),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          right: BorderSide(
                            color: state == HomeState.HOME
                                ? themeColor.secondaryColor
                                : Colors.transparent,
                            width: 3.0,
                          ),
                        )),
                        child: ListTile(
                          leading: Icon(
                            Icons.home,
                            size: 30,
                            color: state == HomeState.HOME
                                ? themeColor.secondaryColor
                                : themeColor.fgColor,
                          ),
                          title: Text(
                            '  Home',
                            style: TextStyle(
                                fontSize: 25,
                                color: state == HomeState.HOME
                                    ? themeColor.secondaryColor
                                    : themeColor.fgColor),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          size: 30,
                          color: themeColor.fgColor,
                        ),
                        title: Text(
                          '  ToDay',
                          style: TextStyle(
                              fontSize: 25, color: themeColor.fgColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, route.taskPage);
                        },
                        child: ListTile(
                          leading: Icon(
                            Icons.task_outlined,
                            size: 30,
                            color: themeColor.fgColor,
                          ),
                          title: Text(
                            '  My Tasks',
                            style: TextStyle(
                                fontSize: 25, color: themeColor.fgColor),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.alarm_on,
                          size: 30,
                          color: themeColor.fgColor,
                        ),
                        title: Text(
                          '  Reminder',
                          style: TextStyle(
                              fontSize: 25, color: themeColor.fgColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.help,
                          size: 30,
                          color: themeColor.fgColor,
                        ),
                        title: Text(
                          '  About',
                          style: TextStyle(
                              fontSize: 25, color: themeColor.fgColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(HomeEvent.PROFILE);
                          Navigator.pop(context);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/picture.jpg"),
                            radius: 20,
                            backgroundColor: themeColor.primaryColor,
                            child: ClipOval(
                                child: !(user?.photoURL ?? "").isEmpty
                                    ? Image.network(
                                        (user?.photoURL ?? ""),
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
                          title: Text(
                            '  ${(user?.displayName ?? "")}',
                            style: TextStyle(
                                fontSize: 25, color: themeColor.fgColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            Widget page = HomePage();
            switch (state) {
              case HomeState.HOME:
                page = HomePage();
                break;
              case HomeState.SETTINGS:
                page = SettingsPage(
                  setParentState: setParentState,
                );
                break;
              case HomeState.PROFILE:
                page = ProfilePage();
                break;
              default:
              // return HomePage();
            }
            return AnimatedSwitcher(
              duration: Duration(seconds: 1),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOutCirc,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: page,
            );
          },
        ),
        bottomNavigationBar:
            BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          return CurvedNavigationBar(
            animationDuration: Duration(seconds: 1),
            index: EnumToString.indexOf(
                HomeState.values, EnumToString.parse(state)),
            backgroundColor: themeColor.bgColor,
            color: themeColor.primaryColor,
            height: 60,
            items: const <Widget>[
              Icon(
                Icons.settings,
                size: 40,
                color: Colors.white,
              ),
              Icon(
                Icons.home,
                size: 40,
                color: Colors.white,
              ),
              Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  context.read<HomeBloc>().add(HomeEvent.SETTINGS);
                  break;
                case 1:
                  context.read<HomeBloc>().add(HomeEvent.HOME);
                  break;
                case 2:
                  context.read<HomeBloc>().add(HomeEvent.PROFILE);
                  break;
                default:
              }
            },
          );
        }),
      ),
    );
  }
}
