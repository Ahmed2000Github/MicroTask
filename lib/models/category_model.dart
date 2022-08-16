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

  Category({
    this.id,
    // this._numberTask,
    this.name,
    this.description,
    // this._numberTaskDone
  });

  Map<String, dynamic> toJson() => {
        'title': name,
        'description': description,
      };
}
