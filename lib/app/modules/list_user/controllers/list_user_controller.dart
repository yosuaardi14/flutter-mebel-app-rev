import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/user_service.dart';
import 'package:get/get.dart';

class ListUserController extends GetxController {
  final UserService service = UserService();
  final isLoading = false.obs;
  final isAll = true.obs;
  final index = 0.obs;

  TextEditingController cari = TextEditingController(text: "");
  List<Map<String, dynamic>>? data = [];
  List<Map<String, dynamic>>? search = [];

  @override
  void onInit() {
    super.onInit();
    listData();
  }

  void listData() async {
    log("list user get data");
    isLoading(true);
    data = [];
    cari.text = "";
    update();
    data = await service.listData(isAll.value).whenComplete(() {
      isLoading(false);
      update();
    }).catchError((error, stackTrace) {
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });
  }

  void searchData() {
    search = [];
    update();
    if (cari.text != "" || cari.text.isNotEmpty) {
      search!.addAll(
          data!.where((element) => searchItems(element["nama"], cari.text)));
      update();
    }
  }
}
