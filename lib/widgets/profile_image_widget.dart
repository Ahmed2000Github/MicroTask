import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/profile/profile_bloc.dart';
import 'package:microtask/blocs/profile/profile_state.dart';
import 'package:microtask/configurations/theme_colors_config.dart';
import 'package:microtask/enums/state_enum.dart';

class ProfileImageWidget extends StatelessWidget {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();

  double size;
  double radius;

  ProfileImageWidget({required this.size, required this.radius});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state.requestState == StateStatus.LOADED) {
        return CircleAvatar(
          backgroundImage: AssetImage("assets/images/picture.jpg"),
          radius: radius,
          backgroundColor: themeColor.primaryColor,
          child: ClipOval(
              child: (state.profile?.image != null)
                  ? Image.memory(
                      (base64Decode(state.profile?.image as String)),
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/picture.jpg",
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    )),
        );
      }
      return CircleAvatar(
        backgroundImage: AssetImage("assets/images/picture.jpg"),
        radius: radius,
        backgroundColor: themeColor.primaryColor,
        child: ClipOval(
            child: Image.asset(
          "assets/images/picture.jpg",
          width: size,
          fit: BoxFit.cover,
        )),
      );
    });
  }
}
