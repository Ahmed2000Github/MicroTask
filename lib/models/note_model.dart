import 'package:hive_flutter/hive_flutter.dart';

part 'note_model.g.dart';

@HiveType(typeId: 7)
class Note {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  DateTime? createdAt;
  @HiveField(4)
  DateTime? updatedAt;
  @HiveField(5)
  String? taskId;
  @HiveField(6)
  String? userId;

  Note({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.taskId,
    this.userId,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        createdAt: json['createdAt'].toDate(),
        updatedAt: json['updatedAt'].toDate(),
        taskId: json['taskId'],
        userId: json['userId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'taskId': taskId,
        'userId': userId,
      };
}
