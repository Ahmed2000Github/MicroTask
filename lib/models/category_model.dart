import 'package:hive_flutter/hive_flutter.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class Category {
  @HiveField(0)
  String? id;
  int? _numberTask;

  int? get numberTask {
    return _numberTask;
  }

  set numberTask(int? numberTask) {
    _numberTask = numberTask;
  }

  int? _numberTaskDone;

  int? get numberTaskDone {
    return _numberTaskDone;
  }

  set numberTaskDone(int? numberTaskDone) {
    _numberTaskDone = numberTaskDone;
  }

  @HiveField(1)
  String? name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? userId;

  Category({
    this.id,
    // this._numberTask,
    this.name,
    this.description,
    this.userId,
    // this._numberTaskDone
  });
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        userId: json['userId'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'userId': userId,
      };
}
