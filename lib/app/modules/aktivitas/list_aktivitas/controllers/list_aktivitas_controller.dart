import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/aktivitas_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/auth_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/pesanan_service.dart';
import 'package:get/get.dart';

class ListAktivitasController extends GetxController {
  final AktivitasService service = AktivitasService();
  final isLoading = false.obs;
  final index = 0.obs;
  List<Map<String, dynamic>>? data = [];
  List<Map<String, dynamic>>? search = [];

  @override
  void onInit() {
    super.onInit();
    listData();
  }

  void listData() async {
    log("list pesanan get data");
    isLoading(true);
    data = [];
    update();
    await service.listData("all").then((value) {
      data = value;
    }).whenComplete(() {
      isLoading(false);
      update();
    }).catchError((error, stackTrace) {
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });
  }
}
