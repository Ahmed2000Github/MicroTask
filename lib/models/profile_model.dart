import 'package:enum_to_string/enum_to_string.dart';

import '../enums/gender_enum.dart';

class Profile {
  String? firstName;
  String? lastName;
  DateTime? birthDay;
  Gender? gender;
  String? avatar;

  Profile(
      {this.firstName, this.lastName, this.birthDay, this.gender, this.avatar});

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'birthDay': birthDay,
        'gender': gender.toString().split('.').last,
        'avatar': avatar,
      };
  factory Profile.fromJson(Map<String, dynamic> data) => Profile(
        firstName: data['firstName'],
        lastName: data['lastName'],
        gender: EnumToString.fromString(Gender.values, data['gender']),
        birthDay: data['birthDay'].toDate(),
        avatar: data['avatar'],
      );
}
