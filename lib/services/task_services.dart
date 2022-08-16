import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/services/notification_service.dart';
import 'package:uuid/uuid.dart';

class TaskServices {
  NotificationServices get notificationServices =>
      GetIt.I<NotificationServices>();
  late final Box box;
  TaskServices() {
    box = Hive.box('tasksBox');
  }

  Task? createTaskService(Task task) {
    print('create');
    task.id = Uuid().v1();
    task.showInToday = true;
    task.notificationId = getLastNotificationsId() + 1;
    if (task.reminder!) {
      _setNotifiations(task);
    }
    box.put(task.id, task);
    return task;
  }

  Task? updateTaskService(Task newTask) {
    print("ddddddddddd   ${newTask.reminder} ");
    if (!(newTask.reminder as bool)) {
      notificationServices.cancelNotifications(newTask.notificationId as int);
    } else if ((newTask.reminder as bool) &&
        newTask.repeatType != null &&
        newTask.status == TaskStatus.TODO) {
      print("update333");
      _setNotifiations(newTask);
    }
    if (newTask.status != TaskStatus.TODO) {
      print("update  ${newTask.notificationId}");
      notificationServices.cancelNotifications(newTask.notificationId as int);
    }
    box.put(newTask.id, newTask);
    return newTask;
  }

  void deleteTaskService(String id) {
    var oldTask = box.get(id) as Task;
    if (oldTask.reminder as bool) {
      notificationServices.cancelNotifications(oldTask.notificationId!);
    }
    box.delete(id);
  }

  List<Task> getTasks(DateTime? date, TaskStatus status, String categoryId) {
    List<Task> list = [];
    Task? task;
    for (var i = 0; i < box.length; i++) {
      task = (box.getAt(i) as Task);
      if (DateFormat('yyyy-MM-dd').format(date!) ==
              DateFormat('yyyy-MM-dd').format(task.startDateTime!) &&
          status == task.status &&
          categoryId == task.categoryId) {
        list.add(task);
      }
    }
    return list;
  }

  List<Task> getTodayTasks() {
    List<Task> list = [];
    Task? task;
    for (var i = 0; i < box.length; i++) {
      task = (box.getAt(i) as Task);

      if (DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
              DateFormat('yyyy-MM-dd').format(task.startDateTime!) &&
          task.showInToday!) list.add(task);
    }
    return list;
  }

  List<Task> getTodayReminderTasks() {
    List<Task> list = [];
    Task? task;
    for (var i = 0; i < box.length; i++) {
      task = (box.getAt(i) as Task);

      if (DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
              DateFormat('yyyy-MM-dd').format(task.startDateTime!) &&
          task.repeatType != null) list.add(task);
    }
    return list;
  }

  int getLastNotificationsId() {
    var max = 0;
    for (var i = 0; i < box.length; i++) {
      var id = (box.getAt(i) as Task).notificationId;
      if (max < id!) max = id;
    }
    print("the max is $max");
    return max;
  }

  List<Task> getIcomingReminderTasks() {
    List<Task> list = [];
    Task? task;
    var now = DateTime.now();
    var tomorowDate =
        DateTime(now.year, now.month, now.day, 0, 0, 0).add(Duration(days: 1));
    var todyDuration = tomorowDate.difference(now);
    for (var i = 0; i < box.length; i++) {
      task = (box.getAt(i) as Task);
      var taskDuration = task.startDateTime?.difference(now);
      if (todyDuration.compareTo(taskDuration!) <= 0 && task.repeatType != null)
        list.add(task);
    }
    return list;
  }

  _setNotifiations(Task task) {
    int id = task.notificationId!;
    String payload = '${task.id}';
    DateTime startDate = DateTime(
            task.startDateTime!.year,
            task.startDateTime!.month,
            task.startDateTime!.day,
            task.startDateTime!.hour,
            task.startDateTime!.minute)
        .subtract(const Duration(minutes: 5));
    print("reminder start at : " + startDate.toString());
    switch (task.repeatType) {
      case RepeatType.None:
        var duration = startDate.difference(DateTime.now());
        print("duration $duration");
        notificationServices.showScuduleNotification(
            id, task.title!, task.description!, duration, payload);
        break;
      case RepeatType.Daily:
        notificationServices.scheduleDailyNotification(id, task.title!,
            task.description!, Time(startDate.hour, startDate.minute), payload);
        break;
      case RepeatType.Weekly:
        notificationServices.scheduleWeeklyNotification(
            id,
            task.title!,
            task.description!,
            startDate.weekday,
            Time(startDate.hour, startDate.minute),
            payload);
        break;
      case RepeatType.Monthly:
        notificationServices.scheduleMonthlyNotification(
            id,
            task.title!,
            task.description!,
            startDate.weekday,
            Time(startDate.hour, startDate.minute),
            payload);
        break;
      case RepeatType.Yearly:
        notificationServices.scheduleYearlyNotification(
            id,
            task.title!,
            task.description!,
            startDate.weekday,
            Time(startDate.hour, startDate.minute),
            payload);
        break;
      default:
    }
  }
}