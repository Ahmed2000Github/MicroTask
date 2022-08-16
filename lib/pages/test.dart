import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/services/notification_service.dart';

class ShowNotifications extends StatefulWidget {
  @override
  State<ShowNotifications> createState() => _ShowNotificationsState();
}

class _ShowNotificationsState extends State<ShowNotifications> {
  NotificationServices get notificationServices =>
      GetIt.I<NotificationServices>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                notificationServices.cancelNotifications(545);
              },
              child: Text("cancel")),
          ElevatedButton(
              onPressed: () {
                var now = DateTime.now().add(Duration(minutes: 4));
                var duration = now.difference(DateTime.now());
                print("strat at : $now");
                print("duration $duration");
                notificationServices.scheduleDailyNotification(
                    545, 'title', 'body', Time(8, 20), 'keyyyyy');
              },
              child: Text("scudeled notificatoion")),
          ElevatedButton(
              onPressed: () {
                notificationServices.showScuduleNotification(
                    2, 'title2', 'body2', Duration(seconds: 3), 'keyyyyy2');
              },
              child: Text("other notificatoion"))
        ],
      )),
    );
  }
}
