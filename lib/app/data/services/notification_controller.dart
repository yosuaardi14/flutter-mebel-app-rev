import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_mebel_app_rev/app/data/services/local_notification_service.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // LocalNotificationService.initialize();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {}
    });

    ///forground
    FirebaseMessaging.onMessage.listen((message) {
      log("messaging");
      if (message.notification != null) {
        log(message.notification.toString());
        log(message.data.toString());
      }
      // LocalNotificationService.display(message);
    });

    ///background tapi minimize dan user klik notif
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }
}
