import 'dart:developer';

import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/aktivitas_service.dart';
import 'package:get/get.dart';

class AddAktivitasController extends GetxController {
  final AktivitasService service = AktivitasService();
  Map<String, dynamic>? detail = {};
  final isLoading = false.obs;

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
    Map<String, dynamic> newData = {};
    newData.addAll(data);

    await service.addData(newData).then((value) {
      Get.back();
      showInfoDialog("Berhasil", "Menambahkan Data");
    }).catchError((error, stackTrace) {
      Get.back();
      showInfoDialog("Gagal", "Menambahkan Data $error");
    });
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
    log("add bahan baku get data");
    isLoading(true);
    detail = {};
    update();
    detail = await service.getData(id).whenComplete(() {
      isLoading(false);
      update();
    }).catchError((error, stackTrace) {
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });
  }
}
