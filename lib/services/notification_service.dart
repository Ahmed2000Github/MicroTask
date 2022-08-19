import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/configurations/configuration.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final selectNotificationSubject = BehaviorSubject<String?>();
  Configuration get configuration => GetIt.I<Configuration>();

  static const IOSInitializationSettings initializationSettingsIOS =
      // ignore: prefer_const_constructors
      IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  final InitializationSettings initializationSettings =
      const InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  Future init({bool initScuduler = false}) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print("payload : $payload");
      }
      // selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    });
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectNotificationSubject.add(notificationAppLaunchDetails?.payload);
    }
  }

  Future showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async {
    flutterLocalNotificationsPlugin.show(
        id, title, body, await _notificationDetails(title, body),
        payload: payload);
  }

  Future showScuduleNotification(
    int id,
    String title,
    String body,
    Duration duration,
    String? payload,
  ) async {
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title.toUpperCase(),
      body,
      tz.TZDateTime.now(tz.local).add(duration),
      await _notificationDetails(title, body) as NotificationDetails,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotifications(int id) async {
    print("delesssss");
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<NotificationDetails?> _notificationDetails(
      String title, String body) async {
    String channelId = configuration.reminderSound
        ? "channel id with sound"
        : "channel id without sound";
    return NotificationDetails(
        android: AndroidNotificationDetails(channelId, 'channel name',
            channelDescription: 'channel description',
            sound: RawResourceAndroidNotificationSound('custom_sound'),
            playSound: configuration.reminderSound,
            styleInformation: BigPictureStyleInformation(
                DrawableResourceAndroidBitmap('@mipmap/notify_task'),
                contentTitle: '<b>' + title.toUpperCase() + '</b>',
                htmlFormatContentTitle: true,
                summaryText: '<i>' + body + '</i>',
                htmlFormatSummaryText: true),
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            fullScreenIntent: true,
            color: Color.fromARGB(255, 68, 148, 247),
            importance: Importance.max),
        iOS: IOSNotificationDetails());
  }

  Future<void> scheduleDailyNotification(
      int id, String title, String body, Time time, String? payload) async {
    print("set daily");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title.toUpperCase(),
      body,
      _nextInstanceOfTime(time),
      await _notificationDetails(title, body) as NotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  Future<void> scheduleWeeklyNotification(int id, String title, String body,
      int weekDay, Time time, String? payload) async {
    print("set weekly");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title.toUpperCase(),
      body,
      _nextInstanceOfDay(weekDay, time),
      await _notificationDetails(title, body) as NotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: payload,
    );
  }

  Future<void> scheduleMonthlyNotification(int id, String title, String body,
      int weekDay, Time time, String? payload) async {
    print("set momthly");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title.toUpperCase(),
      body,
      _nextInstanceOfDay(weekDay, time),
      await _notificationDetails(title, body) as NotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      payload: payload,
    );
  }

  Future<void> scheduleYearlyNotification(int id, String title, String body,
      int weekDay, Time time, String? payload) async {
    print("set yearly");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title.toUpperCase(),
      body,
      _nextInstanceOfDay(weekDay, time),
      await _notificationDetails(title, body) as NotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: payload,
    );
  }

  tz.TZDateTime _nextInstanceOfDay(int weekDay, Time time) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
    while (scheduledDate.weekday != weekDay) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfTime(Time time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var hour = time.hour + (now.hour - DateTime.now().hour);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, time.minute, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
