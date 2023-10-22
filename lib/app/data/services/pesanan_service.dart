import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/bahan_baku_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/user_service.dart';

class PesananService {
  static final PesananService _instance = PesananService._internal();
  factory PesananService() {
    return _instance;
  }
  PesananService._internal();

  final collection = FirebaseFirestore.instance.collection('pesanan-rev');

  Future<List<Map<String, dynamic>>?> listData([String type = ""]) async {
    List<Map<String, dynamic>> data = [];
    if (type == "today") {
      String today = dateToString(DateTime.now());
      log(today);
      await collection
          .where("info.perkiraanSelesai", isEqualTo: today)
          //.where("info.tanggalSelesai", isEqualTo: "")
          .get()
          .then((value) {
        for (var doc in value.docs) {
          if (getPresentaseProgress(doc.data()["progress"]) != 1) {
            data.add(doc.data());
          }
        }
      }).catchError((e) {
        throw (e);
      });
    } else if (type == "selesai") {
      await collection
          .orderBy("info.tanggalPesan")
          //.where("info.tanggalSelesai", isNotEqualTo: "")
          .get()
          .then((value) {
        for (var doc in value.docs) {
          if (getPresentaseProgress(doc.data()["progress"]) == 1) {
            data.add(doc.data());
          }
        }
      }).catchError((e) {
        throw (e);
      });
    } else if (type == "belumSelesai") {
      await collection
          .orderBy("info.tanggalPesan")
          //.where("info.tanggalSelesai", isEqualTo: "")
          .get()
          .then((value) {
        for (var doc in value.docs) {
          if (getPresentaseProgress(doc.data()["progress"]) != 1) {
            data.add(doc.data());
          }
        }
      }).catchError((e) {
        throw (e);
      });
    } else {
      await collection.orderBy("info.tanggalPesan").get().then((value) {
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
    await collection.doc(id).get().then((value) async {
      detail = value.data();
      log("Detail: " + detail.toString());
    }).catchError((e) {
      throw (e);
    });
    return detail;
  }

  Future<Map<String, dynamic>?> getDetailData(String id) async {
    Map<String, dynamic>? detail = {};
    await collection.doc(id).get().then((value) async {
      detail = value.data();
      log("Detail: " + detail.toString());
      detail = await getDataBahanBaku(detail);
      detail = await getDataPekerja(detail);
    }).catchError((e) {
      throw (e);
    });
    return detail;
  }

  Future<Map<String, dynamic>?> getDataPekerja(data) async {
    var adc = UserService();
    List<Map<String, dynamic>>? pekerja = await adc.listData();
    for (var progress in data["progress"]) {
      var temp = pekerja!
          .firstWhere((element) => element["id"] == progress["pekerja"]);
      progress["pekerja"] = temp;
    }
    return data;
  }

  Future<Map<String, dynamic>?> getDataBahanBaku(data) async {
    var bbc = BahanBakuService();
    List<Map<String, dynamic>>? bahanBaku = await bbc.listData();
    for (var bahan in (data["bahanBaku"] as Map<String, dynamic>).keys) {
      var temp = bahanBaku!.firstWhere((element) => element["id"] == bahan);
      temp["jumlah"] = data["bahanBaku"][bahan];
      data["bahanBaku"][bahan] = temp;
    }
    return data;
  }

  Future<String?> addData(Map<String, dynamic> data) async {
    String? id;
    await collection.add(data).then((value) async {
      id = value.id;
      await updateData(value.id, {"id": value.id}, true);
      return value.id;
    }).catchError((e) {
      throw (e);
    });
    return id;
  }

  Future<void> updateData(String id, Map<String, dynamic> data,
      [bool create = false]) async {
    await collection.doc(id).update(data).then((value) {}).catchError((e) {
      throw (e);
    });
  }

  Future<void> deleteData(String id) async {
    await collection.doc(id).delete().then((value) {}).catchError((e) {
      throw (e);
    });
  }
}
