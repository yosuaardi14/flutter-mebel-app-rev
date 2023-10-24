import 'dart:developer';

import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/pesanan_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/user_service.dart';
import 'package:get/get.dart';

class DetailPesananController extends GetxController {
  final PesananService service = PesananService();
  final isLoading = false.obs;
  Map<String, dynamic>? detail = {};

  void getData(String id) async {
    log("detail pesanan get data");
    isLoading(true);
    detail = {};
    update();
    detail = await service.getDetailData(id).whenComplete(() {
      isLoading(false);
      update();
    }).catchError((error, stackTrace) {
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });

    log(detail!.toString());
  }

  void deleteData(String id) async {
    await service.deleteData(id).then((value) async {
      await removeTopic(id);
      Get.back();
      showInfoDialog("Berhasil", "Menghapus Data");
    }).catchError((error, stackTrace) {
      Get.back();
      showInfoDialog("Gagal", "Menghapus Data $error");
    });
  }

  Future<void> removeTopic(String id) async {
    //remove topic from user
    final UserService userService = UserService();
    await userService.removeTopic(detail!["pemesan"]["id"], id);

    //notifikasi
    for (var i = 0; i < detail!["progress"].length; i++) {
      await userService.removeTopic(detail!["progress"][i]["pekerja"]["id"], id);
    }
  }
}
