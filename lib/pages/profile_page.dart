import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:microtask/blocs/logout/logout_bloc.dart';
import 'package:microtask/blocs/profile/profile_bloc.dart';
import 'package:microtask/blocs/profile/profile_event.dart';
import 'package:microtask/blocs/profile/profile_state.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:microtask/configurations/show_case_config.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/enums/gender_enum.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/services/enum_translate_services.dart';
import 'package:microtask/widgets/custom_loading_progress.dart';
import 'package:microtask/widgets/profile_image_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  Configuration get configuration => GetIt.I<Configuration>();
  ShowCaseConfig get showCaseConfig => GetIt.I<ShowCaseConfig>();
  final List<GlobalKey> _list = [
    GlobalKey(),
    GlobalKey(),
  ];
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    context.read<ProfileBloc>().add(
        ProfileEvent(requestEvent: ProfileEventState.LOAD, email: user?.email));
    if (showCaseConfig.isLunched('profile')) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => Future.delayed(Duration(seconds: 1))
            .then((value) => ShowCaseWidget.of(context).startShowCase(_list)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: themeColor.bgColor,
      child: Center(
          child: ListView(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
          child: Showcase(
            key: _list[0],
            showcaseBackgroundColor: themeColor.drowerLightBgClor,
            textColor: themeColor.fgColor,
            description: AppLocalizations.of(context)?.profiled1 ?? '',
            child: ListTile(
              title: Text(
                AppLocalizations.of(context)?.profile ?? '',
                style: TextStyle(
                  fontFamily: configuration.currentFont,
                  fontSize: 30,
                  color: themeColor.fgColor,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.refresh,
                  size: 30,
                  color: themeColor.primaryColor,
                ),
                onPressed: () {
                  context.read<ProfileBloc>().add(ProfileEvent(
                      requestEvent: ProfileEventState.LOAD,
                      email: user?.email));
                },
              ),
            ),
          ),
        ),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            switch (state.requestState) {
              // case StateStatus.NONE:
              //   context.read<ProfileBloc>().add(ProfileEvent(
              //       requestEvent: ProfileEventState.LOAD, email: user?.email));
              //   return Container();
              case StateStatus.LOADING:
                return CustomLoadingProgress(
                    color: themeColor.primaryColor, height: height - 120);
              case StateStatus.ERROR:
                return Container(
                  height: height - 120,
                  child: Center(
                    child: Text(
                      state.messageError.toString(),
                      style: TextStyle(
                        fontFamily: configuration.currentFont,
                        color: themeColor.errorColor,
                        fontSize: 23,
                      ),
                    ),
                  ),
                );

              case StateStatus.LOADED:
                return Container(
                  height: height - 120,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: ProfileImageWidget(size: 200, radius: 100)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.email,
                            size: 30,
                            color: themeColor.secondaryColor,
                          ),
                          title: Text(
                            "${user?.email}",
                            style: TextStyle(
                              fontFamily: configuration.currentFont,
                              fontSize: 18,
                              color: themeColor.fgColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            size: 30,
                            color: themeColor.secondaryColor,
                          ),
                          title: Text(
                            "${(state.profile?.firstName ?? '') + " " + (state.profile?.lastName ?? '')}",
                            style: TextStyle(
                              fontFamily: configuration.currentFont,
                              fontSize: 20,
                              color: themeColor.fgColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(
                            state.profile?.gender == Gender.MALE
                                ? Icons.male_outlined
                                : Icons.female_outlined,
                            size: 30,
                            color: themeColor.secondaryColor,
                          ),
                          title: Text(
                            EnumTranslateServices.translateGender(
                                context, state.profile?.gender as Gender),
                            style: TextStyle(
                              fontFamily: configuration.currentFont,
                              fontSize: 20,
                              color: themeColor.fgColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.date_range,
                            size: 30,
                            color: themeColor.secondaryColor,
                          ),
                          title: Text(
                            "${DateFormat("dd - MM - yyyy").format(state.profile?.birthDay as DateTime)}",
                            style: TextStyle(
                              fontFamily: configuration.currentFont,
                              fontSize: 20,
                              color: themeColor.fgColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            context.read<LogoutBloc>().add(LogoutEvent.LOGOUT);

                            Navigator.pushReplacementNamed(
                                context, route.loginPage);
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.logout,
                              size: 30,
                              color: themeColor.errorColor,
                            ),
                            title: Text(
                              AppLocalizations.of(context)?.logout ?? '',
                              style: TextStyle(
                                fontFamily: configuration.currentFont,
                                fontSize: 20,
                                color: themeColor.errorColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                );

              default:
                return Container();
            }
          },
        )
      ])),
    );
  }
}
