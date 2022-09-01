import 'package:enum_to_string/enum_to_string.dart';
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
  @HiveField(11)
  String? noteId;

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
    this.noteId,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        categoryId: json['categoryId'],
        title: json['title'],
        description: json['description'],
        startDateTime: json['startDateTime'].toDate(),
        endDateTime: json['endDateTime'].toDate(),
        reminder: json['reminder'],
        repeatType:
            EnumToString.fromString(RepeatType.values, json['repeatType']),
        status: EnumToString.fromString(TaskStatus.values, json['status']),
        notificationId: json['notificationId'],
        showInToday: json['showInToday'],
        noteId: json['noteId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'title': title,
        'description': description,
        'startDateTime': startDateTime,
        'endDateTime': endDateTime,
        'reminder': reminder,
        'repeatType': EnumToString.convertToString(repeatType),
        'status': EnumToString.convertToString(status),
        'notificationId': notificationId,
        'showInToday': showInToday,
        'noteId': noteId,
      };
}
