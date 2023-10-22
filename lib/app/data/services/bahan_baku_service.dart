import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class BahanBakuService {
  static final BahanBakuService _instance = BahanBakuService._internal();
  factory BahanBakuService() {
    return _instance;
  }
  BahanBakuService._internal();

  final collection =
      FirebaseFirestore.instance.collection('bahan-baku-testing');

  Future<List<Map<String, dynamic>>?> listData([bool isAll = true]) async {
    List<Map<String, dynamic>> data = [];
    if (isAll) {
      await collection.orderBy("stok").get().then((value) {
        for (var doc in value.docs) {
          data.add(doc.data());
        }
      }).catchError((e) {
        throw (e);
      });
    } else {
      await collection.where("stok", isEqualTo: 0).get().then((value) {
        for (var doc in value.docs) {
          data.add(doc.data());
        }
      }).catchError((e) {
        throw (e);
      });
    }
    return data;
  }

  Future<List<Map<String, dynamic>>?> listDataNotEmpty(
      [Map<String, dynamic>? old]) async {
    List<Map<String, dynamic>> data = [];
    await collection.where("stok", isNotEqualTo: 0).get().then((value) async {
      for (var doc in value.docs) {
        data.add(doc.data());
      }
      if (old != null) {
        for (var kv in old.entries) {
          Map<String, dynamic>? tempBahanBaku = await getData(kv.key);
          if (tempBahanBaku != null) {
            tempBahanBaku[kv.key] = kv.value;
            int index = data.indexWhere((element) => element["id"] == kv.key);
            if (index == -1) {
              data.add(tempBahanBaku);
            }
          }
        }
      }
    }).catchError((e) {
      throw (e);
    });
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

  Future<Map<String, dynamic>?> addData(Map<String, dynamic> data) async {
    await collection.add(data).then((value) async {
      await updateData(value.id, {"id": value.id, "histori-kurang": {}}, true);
    }).catchError((e) {
      throw (e);
    });
    return data;
  }

  Future<Map<String, dynamic>?> updateData(String id, Map<String, dynamic> data,
      [bool create = false]) async {
    await collection
        .doc(id)
        .set(data, SetOptions(merge: true))
        .then((value) {})
        .catchError((e) {
      throw (e);
    });
    return data;
  }

  Future<void> deleteData(String id) async {
    await collection.doc(id).delete().then((value) {}).catchError((e) {
      throw (e);
    });
  }

  Future<void> addStok(String id, Map<String, dynamic> data) async {
    //int stok = oldJumlah;
    await updateData(id, data, false).catchError((e) {
      throw (e);
    });
  }

  Future<void> updateStok(String id, int jumlah, int oldJumlah) async {
    int stok = 0;
    await getData(id).then((value) async {
      if (value != null) {
        stok = value["stok"];
        stok = stok + oldJumlah;
        stok = stok - jumlah;
        log(stok.toString());
        await updateData(id, {"stok": stok}, false);
      }
    }).catchError((e) {
      throw (e);
    });
  }
}
