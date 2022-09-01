import 'package:hive_flutter/hive_flutter.dart';
import 'package:microtask/services/login_services.dart';

class ShowCaseConfig {
  late final Box box;

  late bool _firstLunch = true;
  ShowCaseConfig() {
    box = Hive.box('showCaseBox');
    if (!box.keys.contains('isloged')) {
      box.put('isloged', false);
    }
  }
  bool isLunched(String key) {
    if (LoginServices.isEnterFromLogin) {
      box.put('isloged', true);
      return false;
    }
    if (box.get('isloged') as bool) {
      return false;
    }
    if (box.keys.contains(key)) {
      return false;
    } else {
      box.put(key, true);
      return true;
    }
  }
}
