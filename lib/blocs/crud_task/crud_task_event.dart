import 'package:microtask/enums/event_state.dart';
import 'package:microtask/models/task_model.dart';

class CrudTaskEvent {
  CrudEventStatus requestEvent;
  Task? task;
  String? taskId;

  CrudTaskEvent({required this.requestEvent, this.task, this.taskId});
}
