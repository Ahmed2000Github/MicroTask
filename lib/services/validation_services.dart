import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class ValidationServices {
  static bool isEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  static String? isValidPassword(String value) {
    if (value.length < 8)
      return "The password must containe at least 8 caracters.";
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

  static Future<bool> checkEmail(String value) async {
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

  static sendVerificationEmail(String email) async {
    if (code.isEmpty) {
      code = generateCodeVerification();
      print(code);
      String username = 'testtesttesttesttesttest648@gmail.com';
      String password = 'twgwkfqzbpthjpjs';

      final smtpServer = gmail(username, password);
      final message = Message()
        ..from = Address(username, 'MicorTask')
        ..recipients.add(email)
        ..subject = 'Email verification '
        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html =
            "<h1>Use this code to verify your email.</h1>\n<p>Verification key : <h3><a>$code</a></h3></p>";

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
