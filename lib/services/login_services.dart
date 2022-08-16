import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:microtask/enums/gender_enum.dart';
import 'package:microtask/models/profile_model.dart';
import 'package:microtask/models/user_model.dart';
import 'package:microtask/services/validation_services.dart';

class LoginServices {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final profilesRef = FirebaseFirestore.instance.collection('profiles');
  final key = Key.fromUtf8('My 32 length key................');
  final iv = IV.fromLength(16);

  Future<bool> loginService(String emailAddress, String password) async {
    // try {
    if (!ValidationServices.isEmail(emailAddress)) {
      emailAddress = await getEmailByUsername(emailAddress);
      if (emailAddress == "")
        throw Exception('No Username with the selected identifier');
    }
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    return true;
  }

  Future<String> getEmailByUsername(String? username) async {
    QuerySnapshot querySnapshot = await usersRef.get();
    final users = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    for (var user in users) {
      if (user['username'] == username) {
        return user['email'];
      }
    }
    return "";
  }

  Future<Map<String, dynamic>> getUserIdByEmail(String? email) async {
    QuerySnapshot querySnapshot = await usersRef.get();
    final users = querySnapshot.docs.map((doc) {
      var data = {
        'id': doc.id,
        'email': (doc.data() as Map<String, dynamic>)['email'],
        'password': (doc.data() as Map<String, dynamic>)['password'],
        'profileId': (doc.data() as Map<String, dynamic>)['profileId']
      };
      return data;
    }).toList();
    for (var user in users) {
      if (user['email'] == email) {
        return user;
      }
    }
    return {};
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    final user = await getUserIdByEmail(email);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(newPassword, iv: iv);
    final password = encrypter.decrypt64(user['password'], iv: iv);
    usersRef.doc(user['id']).update({'password': encrypted.base64});
    final userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user?.updatePassword(newPassword);
    return true;
  }

  Future<bool> registerService(
      String firstName,
      String lastName,
      DateTime birthDay,
      Gender gender,
      File image,
      String email,
      String username,
      String password) async {
    String avatar = '';
    if (image != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          "." +
          image.path.split('.').last;
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      avatar = imageUrl.toString();
    }
    final profile = Profile(
        firstName: firstName,
        lastName: lastName,
        birthDay: birthDay,
        gender: gender,
        avatar: avatar);

    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    // final decrypted = encrypter.decrypt(encrypted, iv: iv);

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) async {
      result.user?.updateProfile(displayName: firstName, photoURL: avatar);
      var ref = await profilesRef.add(profile.toJson());
      final user = UserApp(
          email: email,
          username: username,
          password: encrypted.base64,
          profileId: ref.id);
      usersRef.add(user.toJson());
    });
    return true;
  }

  Future<Profile?> getProfile(String? email) async {
    final userData = await getUserIdByEmail(email);
    final profile = await profilesRef.doc(userData['profileId']).get();
    return Profile.fromJson(profile.data() ?? {});
  }
}

// ahmedelrhaouti2000@gmail.com
//    firstName
//    laststName
//    username
//    password2
