import 'dart:developer';

import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/user_service.dart';
import 'package:get/get.dart';

class DetailUserController extends GetxController {
  final UserService service = UserService();
  final isLoading = false.obs;
  Map<String, dynamic>? detail = {};

  void getData(String id) async {
    log("detail user get data");
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

  void deleteData(String id) async {
    await service.deleteData(id).then((value) {
      Get.back();
      showInfoDialog("Berhasil", "Menghapus Data");
    }).catchError((error, stackTrace) {
      Get.back();
      showInfoDialog("Gagal", "Menghapus Data $error");
    });
  }
}
