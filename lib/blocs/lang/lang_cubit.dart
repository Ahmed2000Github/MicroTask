import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:intl/intl.dart';

class LangCubit extends Cubit<Locale> {
  LangCubit(Locale initialState) : super(initialState);

  Configuration get configuration => GetIt.I<Configuration>();

  void changeLang() async {
    var lang = configuration.currentLang;

    if (lang == 'sys') {
      lang = window.locale.languageCode;
      if (!configuration.langs.keys.contains(lang)) {
        lang = 'en';
      }
    }
    var locale = Locale(lang ?? 'en');

    emit(locale);
  }
}
