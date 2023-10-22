import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mebel_app_rev/app/data/services/local_storage_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'user_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() {
    return _instance;
  }
  AuthService._internal();
  static Map<String, dynamic> userData = {};

  UserService userService = UserService();

  Future<Map<String, dynamic>?> login(
      String nohp, String password, bool isPembeli) async {
    Map<String, dynamic>? user;
    await userService.findByNoHP(nohp, password, isPembeli).then((value) {
      if (value!.isEmpty && isPembeli) {
        throw ("No HP tidak ditemukan atau Role bukan Pembeli");
      } else if (value.isEmpty) {
        throw ("No HP atau Password tidak valid");
      }
      user = value;
    }).catchError((e) {
      user = {};
      throw (e);
    });
    return user;
  }

  Future<void> saveLoginData(Map<String, dynamic>? value) async {
    log("message");
    if (value != null) {
      // final prefs = await SharedPreferences.getInstance();
      for (var e in value.entries) {
        if (e.key != "password") {
          if (e.key == "topic") {
            List<String> val = [];
            e.value.forEach((topic) => val.add(topic));
            await LocalStorageService.writeData(e.key, val);
            // prefs.setStringList(e.key, val);
          } else {
            // prefs.setString(e.key, e.value);
            await LocalStorageService.writeData(e.key, value);
          }
          userData[e.key] = e.value;
        }
      }
    }
  }

  Future<bool> loadLoginData() async {
    // final prefs = await SharedPreferences.getInstance();
    // if (prefs.get("id") != null) {
    //   userData["id"] = prefs.getString("id");
    //   Map<String, dynamic>? dataNew = await userService.getData(userData["id"]);
    //   userData["nama"] = prefs.getString("nama");
    //   userData["nohp"] = prefs.getString("nohp");
    //   userData["role"] = prefs.getString("role");
    //   userData["alamat"] = prefs.getString("alamat");
    //   userData["topic"] = prefs.getStringList("topic");
    //   userData["token"] = prefs.getString("token");
    //   if (dataNew != null) {
    //     if (changedData(dataNew, userData)) {
    //       unsubscribeTopic();
    //       saveLoginData(dataNew);
    //     }
    //     checkSubscribeTopic();

    //     return true;
    //   } else {
    //     await logout();
    //   }
    // }
    if (await LocalStorageService.readData("id") != null) {
      userData["id"] = await LocalStorageService.readData("id");
      Map<String, dynamic>? dataNew = await userService.getData(userData["id"]);
      userData["nama"] = await LocalStorageService.readData("nama");
      userData["nohp"] = await LocalStorageService.readData("nohp");
      userData["role"] = await LocalStorageService.readData("role");
      userData["alamat"] = await LocalStorageService.readData("alamat");
      userData["topic"] = await LocalStorageService.readData("topic");
      userData["token"] = await LocalStorageService.readData("token");
      if (dataNew != null) {
        if (changedData(dataNew, userData)) {
          unsubscribeTopic();
          saveLoginData(dataNew);
        }
        checkSubscribeTopic();

        return true;
      } else {
        await logout();
      }
    }
    return false;
  }

  bool changedData(Map<String, dynamic> data, Map<String, dynamic> oldData) {
    if (!listEquals(data["topic"], oldData["topic"])) {
      return true;
    } else {
      for (var i in oldData.keys) {
        if (data[i] != oldData[i] && data[i] is! List) {
          return true;
        }
      }
      return false;
    }
  }

  void checkSubscribeTopic() {
    for (var i in userData["topic"]) {
      FirebaseMessaging.instance.subscribeToTopic(i);
    }
  }

  void unsubscribeTopic() {
    for (var i in userData["topic"]) {
      FirebaseMessaging.instance.unsubscribeFromTopic(i);
    }
  }

  Future<void> logout() async {
    unsubscribeTopic();
    // final prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    await LocalStorageService.removeALl();
    userData.clear();
  }
}
