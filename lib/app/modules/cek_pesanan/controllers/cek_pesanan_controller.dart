import 'dart:developer';

import 'package:flutter_mebel_app_rev/app/data/services/pesanan_service.dart';
import 'package:get/get.dart';

class CekPesananController extends GetxController {
  final PesananService service = PesananService();
  final isLoading = false.obs;
  Map<String, dynamic>? detail = {};

  void getData(String id) async {
    log("cek pesanan get data");
    isLoading(true);
    detail = {};
    update();
    await service
        .getDetailData(id)
        .then((value) => detail = value)
        .whenComplete(() {
      isLoading(false);
      update();
    }).catchError((error, stackTrace) {
      detail = {};
      update();
    });
  }
}
