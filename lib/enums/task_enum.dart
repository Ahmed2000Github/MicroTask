import 'package:hive_flutter/hive_flutter.dart';
part 'task_enum.g.dart';

@HiveType(typeId: 3)
enum TaskStatus {
  @HiveField(0)
  TODO,
  @HiveField(1)
  DOING,
  @HiveField(2)
  DONE,
  @HiveField(4)
  UNDONE
}
@HiveType(typeId: 4)
enum RepeatType {
  @HiveField(0)
  Daily,
  @HiveField(1)
  Weekly,
  @HiveField(2)
  Monthly,
  @HiveField(4)
  Yearly,
  @HiveField(5)
  None
}
