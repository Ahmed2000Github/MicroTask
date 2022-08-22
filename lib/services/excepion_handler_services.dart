import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExceptionHandler {
  Locale locale;

  ExceptionHandler({required this.locale});
  Future<String> handleFirebaseAuthException(FirebaseAuthException e) async {
    String errormessage = '';
    final app = await AppLocalizations.delegate.load(locale);
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        errormessage = app.eRROR_INVALID_EMAIL;
        break;
      case "ERROR_WRONG_PASSWORD":
        errormessage = app.eRROR_WRONG_PASSWORD;
        break;
      case "ERROR_USER_NOT_FOUND":
        errormessage = app.eRROR_USER_NOT_FOUND;
        break;
      case "ERROR_USER_DISABLED":
        errormessage = app.eRROR_USER_DISABLED;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errormessage = app.eRROR_TOO_MANY_REQUESTS;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errormessage = app.eRROR_OPERATION_NOT_ALLOWED;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        errormessage = app.eRROR_EMAIL_ALREADY_IN_USE;
        break;
      default:
        errormessage = app.eRROR_UNDEFINED;
    }
    return errormessage;
  }

  Future<String> handleSocketException(SocketException e) async {
    String errormessage = '';
    final app = await AppLocalizations.delegate.load(locale);
    errormessage = app.eRROR_No_CONNECTION;

    return errormessage;
  }

  Future<String> handleException(e) async {
    String errormessage = '';
    final app = await AppLocalizations.delegate.load(locale);
    errormessage = app.eRROR_UNDEFINED;

    return errormessage;
  }
}
