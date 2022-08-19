import 'package:hive/hive.dart';

part 'gender_enum.g.dart';

@HiveType(typeId: 5)
enum Gender {
  @HiveField(0)
  MALE,
  @HiveField(1)
  FEMALE
}
