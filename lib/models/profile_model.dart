import 'package:enum_to_string/enum_to_string.dart';
import 'package:hive/hive.dart';

import '../enums/gender_enum.dart';
part 'profile_model.g.dart';

@HiveType(typeId: 6)
class Profile {
  @HiveField(0)
  String? firstName;
  @HiveField(1)
  String? lastName;
  @HiveField(2)
  DateTime? birthDay;
  @HiveField(3)
  Gender? gender;
  @HiveField(4)
  String? avatar;
  @HiveField(5)
  String? image;

  Profile(
      {this.firstName,
      this.lastName,
      this.birthDay,
      this.gender,
      this.avatar,
      this.image});

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
