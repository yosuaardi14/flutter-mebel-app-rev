import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart';

class LocalNotificationService {
  // static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // static void initialize() {
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           android: AndroidInitializationSettings("@mipmap/ic_launcher"));

  //   _notificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: (String? route) async {
  //     if (route != null) {}
  //   });
  // }

  // static void display(RemoteMessage message) async {
  //   try {
  //     int id = int.parse(message.data["id"].toString());
  //     final schedule = message.data["isScheduled"].toString() == "true";
  //     final daily = message.data["daily"].toString() == "true";
  //     log(schedule.toString());
  //     const NotificationDetails notificationDetails = NotificationDetails(
  //         android: AndroidNotificationDetails(
  //       "flutter-mebel-app",
  //       "flutter-mebel-app channel",
  //       channelDescription: "flutter-mebel-app",
  //       importance: Importance.max,
  //       priority: Priority.high,
  //     ));

  //     if (daily && schedule) {
  //       final scheduledTime = DateTime.parse(message.data["scheduledTime"]);
  //       initializeTimeZones();
  //       tz.setLocalLocation(tz.getLocation("Asia/Jakarta"));
  //       await _notificationsPlugin.zonedSchedule(
  //           id, 
  //           message.notification!.title,
  //           message.notification!.body,
  //           dailySetTime(scheduledTime.hour, scheduledTime.minute),
  //           notificationDetails,
  //           androidAllowWhileIdle: true,
  //           uiLocalNotificationDateInterpretation:
  //               UILocalNotificationDateInterpretation.absoluteTime,
  //           matchDateTimeComponents: DateTimeComponents.time);
  //     } else if (schedule) {
  //       final scheduledTime = DateTime.parse(message.data["scheduledTime"]);
  //       initializeTimeZones();
  //       tz.setLocalLocation(tz.getLocation("Asia/Jakarta"));
  //       await _notificationsPlugin.zonedSchedule(
  //         id,
  //         message.notification!.title,
  //         message.notification!.body,
  //         tz.TZDateTime.from(scheduledTime, tz.local),
  //         notificationDetails,
  //         androidAllowWhileIdle: true,
  //         uiLocalNotificationDateInterpretation:
  //             UILocalNotificationDateInterpretation.absoluteTime,
  //       );
  //     } else if (daily) {
  //       initializeTimeZones();
  //       tz.setLocalLocation(tz.getLocation("Asia/Jakarta"));
  //       await _notificationsPlugin.periodicallyShow(
  //           id,
  //           message.notification!.title,
  //           message.notification!.body,
  //           RepeatInterval.daily,
  //           notificationDetails,
  //           androidAllowWhileIdle: true);
  //     } else {
  //       log("show notif");
  //       await _notificationsPlugin.show(
  //         id,
  //         message.notification!.title,
  //         message.notification!.body,
  //         notificationDetails,
  //       );
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //   }
  // }

  // static void cancelAllNotification() async {
  //   await _notificationsPlugin.cancelAll();
  // }

  // static void cancelNotification(int id) async {
  //   await _notificationsPlugin.cancel(id);
  // }

  // static tz.TZDateTime dailySetTime(int hour, int minute) {
  //   initializeTimeZones();
  //   tz.setLocalLocation(tz.getLocation("Asia/Jakarta"));
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduledDate = tz.TZDateTime(tz.getLocation("Asia/Jakarta"),
  //       now.year, now.month, now.day, hour, minute);
  //   if (scheduledDate.isBefore(now)) {
  //     log("isBefore");
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }
}
