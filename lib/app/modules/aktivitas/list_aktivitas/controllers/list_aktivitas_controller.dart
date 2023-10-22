import 'dart:developer';

import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/aktivitas_service.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:get/get.dart';

class ListAktivitasController extends GetxController {
  final AktivitasService service = AktivitasService();
  final status = Rx<Status>(Status.none);
  bool isError = false;

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
    status(Status.loading);
    data = [];
    update();
    try {
      await service.listData("all").then((value) {
        data = value;
      });
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
}
