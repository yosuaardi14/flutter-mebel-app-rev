import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/bahan_baku_service.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:get/get.dart';

class ListBahanBakuController extends GetxController {
  final BahanBakuService service = BahanBakuService();
  // final isLoading = false.obs;
  final status = Rx<Status>(Status.none);
  bool isError = false;
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
    log("list user get data");
    status(Status.loading);
    data = [];
    cari.text = "";
    update();
    try {
      data = await service.listData(isAll.value);
    } catch (e) {
      isError = true;
      showInfoDialog("Gagal", "Menampilkan Data $e");
    } finally {
      if (isError) {
        status(Status.error);
      } else {
        if (data?.isEmpty ?? false) {
          status(Status.empty);
        } else {
          status(Status.success);
        }
      }
      update();
    }
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
