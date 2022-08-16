import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/task_model.dart';

class TodayState {
  StateStatus requestState;
  List<Task>? todayTasks;
  String? errormessage;
  TodayState({required this.requestState, this.todayTasks, this.errormessage});
}
