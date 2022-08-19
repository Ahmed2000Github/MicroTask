import 'package:hive_flutter/hive_flutter.dart';

class Configuration {
  bool _reminderSound = true;

  bool get reminderSound => _reminderSound;

  set reminderSound(bool reminderSound) {
    _reminderSound = reminderSound;
    box.put("_reminderSound", _reminderSound);
  }

  int _remindeTime = 5;

  int get remindeTime => _remindeTime;

  set remindeTime(int remindeTime) {
    _remindeTime = remindeTime;
    box.put("_remindeTime", _remindeTime);
  }

  bool _isAutoSyncronize = true;

  bool get isAutoSyncronize => _isAutoSyncronize;

  set isAutoSyncronize(bool isAutoSyncronize) {
    _isAutoSyncronize = isAutoSyncronize;
    box.put("_isAutoSyncronize", _isAutoSyncronize);
  }

  late final Box box;
  Configuration() {
    box = Hive.box('configurationsBox');
    if (!box.keys.contains('_remindeTime')) {
      box.put("_remindeTime", _remindeTime);
    } else {
      _remindeTime = box.get("_remindeTime");
    }
    if (!box.keys.contains('_isAutoSyncronize')) {
      box.put("_isAutoSyncronize", _isAutoSyncronize);
    } else {
      _isAutoSyncronize = box.get("_isAutoSyncronize");
    }
    if (!box.keys.contains('_reminderSound')) {
      box.put("_reminderSound", _reminderSound);
    } else {
      _reminderSound = box.get("_reminderSound");
    }
  }
}
