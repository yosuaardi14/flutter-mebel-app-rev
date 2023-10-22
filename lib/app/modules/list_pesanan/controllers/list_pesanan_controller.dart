import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/auth_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/pesanan_service.dart';
import 'package:get/get.dart';

class ListPesananController extends GetxController {
  final PesananService service = PesananService();
  final isLoading = false.obs;
  final type = "today".obs;
  final index = 0.obs;
  TextEditingController cari = TextEditingController(text: "");
  List<Map<String, dynamic>>? data = [];
  List<Map<String, dynamic>>? search = [];

  @override
  void onInit(){
    super.onInit();
    listData();
  }

  void listData() async {
    log("list pesanan get data");
    isLoading(true);
    data = [];
    cari.text = "";
    update();
    await service.listData(type.value).then((value) {
      data = value;
      if (AuthService.userData["role"] == "Pekerja") {
        List<Map<String, dynamic>> temp = [];
        for (var item in data!) {
          for (var i = 0; i < item["progress"].length; i++) {
            if (item["progress"][i]["pekerja"] == AuthService.userData["id"]) {
              temp.add(item);
              break;
            }
          }
        }
        data = temp;
      } else if (AuthService.userData["role"] == "Pembeli") {
        List<Map<String, dynamic>> temp = [];
        for (var item in data!) {
          if (item["pemesan"]["id"] == AuthService.userData["id"]) {
            temp.add(item);
          }
        }
        data = temp;
      }
    }).whenComplete(() {
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
      search!.addAll(data!
          .where((element) => searchItems(element["info"]["nama"], cari.text)));
      update();
    }
  }
}
