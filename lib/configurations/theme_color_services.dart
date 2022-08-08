import 'package:flutter/cupertino.dart';

class ThemeColor {
  bool isDarkMod = false;

  Color get bgColor {
    if (isDarkMod) {
      return Color(0xff000000);
    }
    return Color(0xffffffff);
  }

  Color get fgColor {
    if (isDarkMod) {
      return Color(0xffffffff);
    }
    return Color(0xff000000);
  }

  Color get primaryColor {
    return Color(0xff0280ee);
  }

  Color get secondaryColor {
    return Color(0xff3bf19d);
  }

  Color get inputbgColor {
    return Color(0xff8bc6fe);
  }

  Color get errorColor {
    return Color(0xffff3540);
  }

  Color get drowerBgClor {
    if (isDarkMod) {
      return Color(0xff222222);
    }
    return Color(0xffeeeeee);
  }
}
