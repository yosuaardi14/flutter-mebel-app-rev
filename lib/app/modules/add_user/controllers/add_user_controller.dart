import 'dart:developer';

import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/user_service.dart';
import 'package:get/get.dart';

class AddUserController extends GetxController {
  final UserService service = UserService();
  Map<String, dynamic>? detail = {};
  final isLoading = false.obs;

  String role = "";

  bool isSaving = false;

  void simpan(String? id, Map<String, dynamic> data) {
    isSaving = true;
    update();
    if (id == null) {
      tambahData(data);
    } else {
      editData(id, data);
    }
  }

  void tambahData(Map<String, dynamic> data) async {
    if (await service.findDuplicate("nohp", data["nohp"]) == "") {
      await service.addData(data).then((value) {
        Get.back();
        showInfoDialog("Berhasil", "Menambahkan Data");
      }).catchError((error, stackTrace) {
        Get.back();
        showInfoDialog("Gagal", "Menambahkan Data $error");
      });
    } else {
      showInfoDialog("Gagal", "Menambahkan Data Nomor HP telah terdaftar");
      isSaving = false;
      update();
    }
  }

  void editData(String id, Map<String, dynamic> data) async {
    await service.updateData(id, data).then((value) {
      Get.back();
      showInfoDialog("Berhasil", "Mengubah Data");
    }).catchError((error, stackTrace) {
      Get.back();
      showInfoDialog("Gagal", "Mengubah Data $error");
    });
  }

  void getData(String id) async {
    log("add user get data");
    isLoading(true);
    detail = {};
    update();
    detail = await service.getData(id).catchError((error, stackTrace) {
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });
    isLoading(false);
    role = detail!["role"];
    update();
  }
}
