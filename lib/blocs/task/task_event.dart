import 'package:microtask/enums/event_state.dart';

class TaskEvent {
  CrudEventStatus requestEvent;
  DateTime date;
  String categoryId;

  TaskEvent(
      {required this.requestEvent,
      required this.date,
      required this.categoryId});
}
