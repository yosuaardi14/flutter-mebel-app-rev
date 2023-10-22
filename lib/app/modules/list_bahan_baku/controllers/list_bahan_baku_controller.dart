import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/bahan_baku_service.dart';
import 'package:get/get.dart';

class ListBahanBakuController extends GetxController {
  final BahanBakuService service = BahanBakuService();
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
    log("list bahan baku get data");
    isLoading(true);
    data = [];
    cari.text = "";
    update();
    data = await service.listData(isAll.value).catchError((error, stackTrace) {
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });
    // data!.sort((a, b) {
    //   return a["stok"].compareTo(b["stok"]);
    // });
    isLoading(false);
    update();
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
