import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_connect/connect.dart';

class FCMService extends GetConnect {
  final String url = "https://fcm.googleapis.com/fcm/send";
  final String apiKey = "AIzaSyC5cICBq6C_R-gMFMXu04HkqMfcjtTz_Hw";
  final String serverKey =
      "AAAACyRavEA:APA91bHpc62yxHQ8w2-qv7Q7AW3gTncF0d4cfO1UWjrddm_IgrOyb58r1DE1pr5PCsW2FWhCxTyU5w6sYnvpS8uO7HWhigt9bXDPu3Wvr9rJTUiWtT2zS9WnlOyQgq6nTPMlfadeK0Jf";
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    httpClient.timeout = const Duration(seconds: 60);
  }

  Future<bool> sendTopicDailyNotification(
      String topic, String title, String body, int id,
      {bool scheduled = false, bool daily = false, String time = ""}) async {
    Map<String, dynamic> data = {
      "to": "/topics/$topic",
      "notification": {"title": title, "body": body},
      "data": {
        "isScheduled": scheduled,
        "scheduledTime": time,
        "daily": daily,
        "id": id
      }
    };
    final response = await httpClient.post(
      url,
      headers: {'Authorization': 'key=$serverKey'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }
}
