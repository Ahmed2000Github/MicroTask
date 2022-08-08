import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/profile/profile_bloc.dart';
import 'package:microtask/blocs/profile/profile_event.dart';
import 'package:microtask/blocs/profile/profile_state.dart';
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/enums/state_enum.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    context.read<ProfileBloc>().add(
        ProfileEvent(requestEvent: ProfileEventState.LOAD, email: user?.email));
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
          child: ListTile(
            title: Text(
              "Profile Settings",
              style: TextStyle(
                fontSize: 30,
                color: themeColor.fgColor,
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
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              case StateStatus.ERROR:
                return Container(
                  child: Center(
                    child: Text(
                      state.messageError.toString(),
                      style: TextStyle(
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
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/picture.jpg"),
                            radius: 100,
                            backgroundColor: themeColor.primaryColor,
                            child: ClipOval(
                                child: !(user?.photoURL ?? "").isEmpty
                                    ? Image.network(
                                        (user?.photoURL ?? ""),
                                        width: 200,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/images/picture.jpg",
                                        width: 200,
                                        fit: BoxFit.cover,
                                      )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.email,
                            size: 30,
                            color: themeColor.fgColor,
                          ),
                          title: Text(
                            "${user?.email}",
                            style: TextStyle(
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
                            Icons.person,
                            size: 30,
                            color: themeColor.fgColor,
                          ),
                          title: Text(
                            // "${(state.profile?.firstName ?? '') + " " + (state.profile?.lastName ?? '')}",
                            "${user?.displayName}",
                            style: TextStyle(
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
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushNamed(context, route.loginPage);
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.logout,
                              size: 30,
                              color: themeColor.fgColor,
                            ),
                            title: Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 20,
                                color: themeColor.fgColor,
                              ),
                            ),
                          ),
                        ),
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
