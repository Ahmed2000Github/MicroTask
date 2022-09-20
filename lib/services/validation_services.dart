import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ValidationServices {
  static bool isEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  static String? isValidPassword(BuildContext context, String value) {
    if (value.length < 8)
      return AppLocalizations.of(context)?.passwordValidation1 ?? '';
    return null;
  }

  static Future<bool> checkUser(String value) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    final users = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    for (var user in users) {
      if (user['username'] == value) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> checkEmail(BuildContext context, String value) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    final users = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    for (var user in users) {
      if (user['email'] == value) {
        return true;
      }
    }
    return false;
  }

  static sendVerificationEmail(BuildContext context, String email) async {
    if (code.isEmpty) {
      code = generateCodeVerification();
      print(code);
      String username = 'testtesttesttestesttest648@gmail.com';
      String password = 'twgwkfqzbpthjpjs';

      final smtpServer = gmail(username, password);
      final message = Message()
        ..from = Address(username, 'MicorTask')
        ..recipients.add(email)
        ..subject = AppLocalizations.of(context)?.emailSubject ?? ''
        ..html = "<h1>" +
            (AppLocalizations.of(context)?.emailHtmlText1 ?? '') +
            "</h1>\n<p>" +
            (AppLocalizations.of(context)?.emailHtmlText2 ?? '') +
            "<h3><a>$code</a></h3></p>";

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      print("sendedddddddddd");
    }
  }

  static String code = '';

  static String generateCodeVerification() {
    String randomCode = "M-";
    for (var i = 0; i < 5; i++) {
      randomCode += Random().nextInt(9).toString();
    }
    return randomCode;
  }
}
