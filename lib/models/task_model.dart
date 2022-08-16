import 'package:hive_flutter/hive_flutter.dart';
import 'package:microtask/enums/task_enum.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? categoryId;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? description;
  @HiveField(4)
  DateTime? startDateTime;
  @HiveField(5)
  DateTime? endDateTime;
  @HiveField(6)
  TaskStatus? status;
  @HiveField(7)
  bool? reminder;
  @HiveField(8)
  RepeatType? repeatType;
  @HiveField(9)
  int? notificationId;
  @HiveField(10)
  bool? showInToday;

  Task({
    this.id,
    this.categoryId,
    this.title,
    this.description,
    this.startDateTime,
    this.endDateTime,
    this.reminder,
    this.status,
    this.repeatType,
    this.notificationId,
    this.showInToday,
  });

  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(title: json['title']);

  Map<String, dynamic> toJson(Task task) => {
        'title': task.title,
      };
}
