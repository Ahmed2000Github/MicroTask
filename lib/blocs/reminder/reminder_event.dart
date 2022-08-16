import 'package:microtask/models/task_model.dart';

class ReminderEvent {
  ReminderEventStatus requestEvent;
  Task? task;
  ReminderEvent({required this.requestEvent, this.task});
}

enum ReminderEventStatus { TODAY, INCOMING }
