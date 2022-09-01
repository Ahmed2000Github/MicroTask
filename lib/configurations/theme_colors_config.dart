import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeColor {
  bool _isDarkMod = false;
  late final Box box;
  ThemeColor() {
    box = Hive.box('colorsBox');
    if (!box.keys.contains('_isDarkMod')) {
      var brightness = SchedulerBinding.instance?.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      box.put("_isDarkMod", isDarkMode);
    } else {
      _isDarkMod = box.get("_isDarkMod");
    }
  }

  bool get isDarkMod => _isDarkMod;

  set isDarkMod(bool isDarkMod) {
    _isDarkMod = isDarkMod;
    box.put("_isDarkMod", isDarkMod);
  }

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

  Color get primaryLightColor {
    return Color(0xff63ccff);
  }

  Color get secondaryColor {
    if (isDarkMod) {
      return Color(0xff3bf19d);
    }
    return Color(0xff2ae08c);
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

  Color get drowerLightBgClor {
    if (isDarkMod) {
      return Color(0xff424242);
    }
    return Color(0xffE0E0E0);
  }
}
