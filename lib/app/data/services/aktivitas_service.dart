import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mebel_app_rev/app/data/services/base_firestore_service.dart';

class AktivitasService extends BaseFirestoreService {
  static AktivitasService? _instance;

  // Private constructor that calls the base class constructor
  AktivitasService._internal() : super.internal("aktivitas");

  // Factory constructor for the extended class
  factory AktivitasService() {
    _instance ??= AktivitasService._internal();
    return _instance!;
  }

  Future<List<Map<String, dynamic>>?> listData([String tahap = ""]) async {
    List<Map<String, dynamic>> data = [];
    if (tahap == "all") {
      await collection.get().then((value) {
        for (var doc in value.docs) {
          data.add(doc.data());
        }
      }).catchError((e) {
        throw (e);
      });
    } else {
      await collection.where("tahap", isEqualTo: tahap).get().then((value) {
        for (var doc in value.docs) {
          data.add(doc.data());
        }
      }).catchError((e) {
        throw (e);
      });
    }
    return data;
  }

  Future<Map<String, dynamic>?> getData(String id) async {
    Map<String, dynamic>? detail = {};
    await collection.doc(id).get().then((value) {
      detail = value.data();
    }).catchError((e) {
      throw (e);
    });
    return detail;
  }

  Future<void> addData(Map<String, dynamic> data) async {
    int len = 0;
    await collection.get().then((value) {
      len = value.size;
      log(len.toString());
    }).catchError((e) {
      throw (e);
    });
    data["id"] = "aktivitas${len + 1}";
    await collection
        .doc("aktivitas${len + 1}")
        .set(data, SetOptions(merge: true))
        .then((value) {
      // await updateData(value.id, {"id": value.id}, true);
    }).catchError((e) {
      throw (e);
    });
  }

  Future<void> updateData(String id, Map<String, dynamic> data,
      [bool create = false]) async {
    await collection
        .doc(id)
        .set(data, SetOptions(merge: true))
        .then((value) {})
        .catchError((e) {
      throw (e);
    });
  }

  Future<void> deleteData(String id) async {
    await collection.doc(id).delete().then((value) {}).catchError((e) {
      throw (e);
    });
  }

  Future<String?> addNewPembeli(Map<String, dynamic> data) async {
    String? id;
    await collection.add(data).then((value) async {
      id = value.id;
      await updateData(
          value.id,
          {
            "id": value.id,
            "token": "",
            "topic": [],
            "role": "Pembeli",
            "password": ""
          },
          true);
    }).catchError((e) {
      throw (e);
    });
    log(id.toString());
    return id;
  }
}
