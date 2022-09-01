import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:microtask/configurations/configuration.dart';

class ExceptionHandler {
  Configuration get configuration => GetIt.I<Configuration>();
  Future<String> handleFirebaseAuthException(FirebaseAuthException e) async {
    var locale = configuration.GetLocale();

    final app = await AppLocalizations.delegate.load(locale);
    String errormessage = '';
    print('errro ${e.code}');
    switch (e.code) {
      case "invalid-email":
        errormessage = app.eRROR_INVALID_EMAIL;
        break;
      case "wrong-password":
        errormessage = app.eRROR_WRONG_PASSWORD;
        break;
      case "user-not-found":
        errormessage = app.eRROR_USER_NOT_FOUND;
        break;
      case "user-disabled":
        errormessage = app.eRROR_USER_DISABLED;
        break;
      case "too-many-requests":
        errormessage = app.eRROR_TOO_MANY_REQUESTS;
        break;
      case "operation-not-allowed":
        errormessage = app.eRROR_OPERATION_NOT_ALLOWED;
        break;
      case "email-already-in-use":
        errormessage = app.eRROR_EMAIL_ALREADY_IN_USE;
        break;
      default:
        errormessage = app.eRROR_UNDEFINED;
    }
    return errormessage;
  }

  Future<String> handleSocketException(SocketException e) async {
    var locale = configuration.GetLocale();

    String errormessage = '';
    final app = await AppLocalizations.delegate.load(locale);
    errormessage = app.eRROR_No_CONNECTION;

    return errormessage;
  }

  Future<String> handleException(e) async {
    var locale = configuration.GetLocale();

    String errormessage = '';
    final app = await AppLocalizations.delegate.load(locale);
    errormessage = app.eRROR_UNDEFINED;

    return errormessage;
  }
}
