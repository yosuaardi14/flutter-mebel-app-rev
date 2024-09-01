import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/aktivitas_service.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/views/add_aktivitas_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/list_aktivitas/views/list_aktivitas_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ListAktivitasController extends BaseController<ListAktivitasPage> {
  @override
  Widget build(BuildContext context) => ListAktivitasView(state: this);

  final AktivitasService service = AktivitasService();
  final status = ValueNotifier<Status>(Status.none);
  bool isError = false;

  final index = 0.obs;
  // List<Map<String, dynamic>>? data = [];
  final data = ValueNotifier<List<Map<String, dynamic>>?>([]);
  List<Map<String, dynamic>>? search = [];

  @override
  void initState() {
    super.initState();
    listData();
  }

  void onTambahAktivitas() async {
    Navigator.pushNamed(context, Routes.ADD_ACTIVITY).whenComplete(
      () => listData(),
    );
  }

  void onEditAktivitas(String id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAktivitasPage(id: id),
      ),
    ).whenComplete(
      () => listData(),
    );
  }

  void listData() async {
    log("list pesanan get data");
    status.value = Status.loading;
    isError = false;
    data.value = [];
    service.listData("all").then((value) {
      data.value = value;
    }).catchError((e, stackTree) {
      isError = true;
      showInfoDialog("Gagal", "Menampilkan Data $e");
    }).whenComplete(() {
      if (isError) {
        status.value = Status.error;
      } else {
        if (data.value?.isEmpty ?? false) {
          status.value = Status.empty;
        } else {
          status.value = Status.success;
        }
      }
    });
  }
}
