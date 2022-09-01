import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  String? _currentFont;

  String? get currentFont => _currentFont;

  set currentFont(String? currentFont) {
    _currentFont = currentFont;
    box.put("_currentFont", _currentFont);
  }

  Map<String, String> fonts = {
    'Roboto': 'default',
    'Becky': 'Becky',
    'Pixelletters': 'Pixel letters',
    'ToThePoint': 'To the Point',
  };

  String? _currentLang;

  String? get currentLang => _currentLang ?? 'en';

  Map<String, String> langs = {
    'ar': '',
    'es': '',
    'fr': '',
    'en': '',
    'sys': '',
  };

  bool? _showHearder;

  bool? get showHearder => _showHearder;

  set showHearder(bool? showHearder) {
    _showHearder = showHearder;
    box.put("_showHearder", _showHearder);
  }

  late final Box box;
  Configuration(Locale locale) {
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
    if (!box.keys.contains('_currentFont')) {
      _currentFont = 'default';
      box.put("_currentFont", _currentFont);
    } else {
      _currentFont = box.get("_currentFont");
    }
    if (!box.keys.contains('_showHearder')) {
      _showHearder = true;
      box.put("_showHearder", _showHearder);
    } else {
      _showHearder = box.get("_showHearder");
    }
    if (!box.keys.contains('_currentLang')) {
      _currentLang = 'sys';
      box.put("_currentLang", _currentLang);
    } else {
      _currentLang = box.get("_currentLang");
    }
    locale = getLocale(_currentLang ?? 'sys');
    initiateListe(locale);
  }

  Future<void> initiateListe(Locale locale) async {
    var app = await AppLocalizations.delegate.load(locale);
    langs = {
      'ar': app.arLang,
      'es': app.esLang,
      'fr': app.frLang,
      'en': app.enLang,
      'sys': app.sysLang,
    };
  }

  setCurrentLang(String? currentLang) async {
    Locale locale = Locale(currentLang == 'sys'
        ? (langs.keys.contains(window.locale.languageCode)
            ? window.locale.languageCode
            : 'en')
        : (currentLang ?? 'en'));
    _currentLang = currentLang;
    await box.put("_currentLang", _currentLang);
    await initiateListe(locale);
  }

  Locale getLocale(String langCode) {
    if (langCode == 'sys') {
      if (!langs.keys.contains(window.locale.languageCode)) {
        return const Locale('en');
      }
      return Locale(window.locale.languageCode);
    }
    return Locale(langCode);
  }

  Locale GetLocale() {
    if (currentLang == 'sys') {
      if (!langs.keys.contains(window.locale.languageCode)) {
        return const Locale('en');
      }
      return Locale(window.locale.languageCode);
    }
    return Locale(currentLang ?? 'en');
  }
}
