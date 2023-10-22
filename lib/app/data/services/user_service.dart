import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() {
    return _instance;
  }
  UserService._internal();

  final collection = FirebaseFirestore.instance.collection('user-testing');

  Future<List<Map<String, dynamic>>?> listData([bool isAll = true]) async {
    List<Map<String, dynamic>> data = [];
    if (isAll) {
      await collection.get().then((value) {
        for (var doc in value.docs) {
          data.add(doc.data());
        }
      }).catchError((e) {
        throw (e);
      });
    } else {
      await collection.where("role", isEqualTo: "Pekerja").get().then((value) {
        for (var doc in value.docs) {
          data.add(doc.data());
        }
      }).catchError((e) {
        throw (e);
      });
    }
    return data;
  }

  Future<List<Map<String, dynamic>>?> listDataNotPembeli() async {
    List<Map<String, dynamic>> data = [];
    await collection.where("role", isNotEqualTo: "Pembeli").get().then((value) {
      for (var doc in value.docs) {
        data.add(doc.data());
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

  Future<void> addData(Map<String, dynamic> data) async {
    await collection.add(data).then((value) async {
      await updateData(
          value.id, {"id": value.id, "token": "", "topic": []}, true);
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

  Future<void> addTopic(String id, String topic) async {
    await collection
        .doc(id)
        .update({
          "topic": FieldValue.arrayUnion([topic])
        })
        .then((value) {})
        .catchError(
          (e) {
            throw (e);
          },
        );
  }

  Future<void> removeTopic(String id, String topic) async {
    await collection
        .doc(id)
        .update({
          "topic": FieldValue.arrayRemove([topic])
        })
        .then((value) {})
        .catchError(
          (e) {
            throw (e);
          },
        );
  }

  Future<String> findDuplicate(String key, String value) async {
    String userid = "";
    await collection.where(key, isEqualTo: value).get().then((value) {
      if (value.docs.isNotEmpty) {
        userid = value.docs.first.data()["id"];
      }
    }).catchError((e) {
      throw (e);
    });
    return userid;
  }

  Future<Map<String, dynamic>?> findByNoHP(
      String nohp, String pass, bool isPembeli) async {
    Map<String, dynamic>? user = {};
    if (!isPembeli) {
      await collection
          .where("nohp", isEqualTo: nohp)
          .where("password", isEqualTo: pass)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          user = value.docs.first.data();
        }
      }).catchError((e) {
        throw (e);
      });
    } else {
      await collection
          .where("nohp", isEqualTo: nohp)
          .where("role", isEqualTo: "Pembeli")
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          user = value.docs.first.data();
        }
      }).catchError((e) {
        throw (e);
      });
    }
    return user;
  }
}
