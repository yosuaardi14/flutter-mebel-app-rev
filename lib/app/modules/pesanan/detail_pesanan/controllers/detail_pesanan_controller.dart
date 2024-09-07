// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/pesanan_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/user_service.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/views/add_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/detail_pesanan/views/detail_pesanan_view.dart';

class DetailPesananController extends BaseController<DetailPesananPage> {
  @override
  Widget build(BuildContext context) => DetailPesananView(state: this);

  final PesananService service = PesananService();
  final isLoading = ValueNotifier<bool>(false);
  final detail = ValueNotifier<Map<String, dynamic>?>({});

  String? get id => widget.id;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void onEditPesanan(String id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPesananPage(id: id),
      ),
    ).whenComplete(getData);
  }

  void onDeletePesanan() async {
    showConfirmationDeleteDialog(context).then((value) {
      if (value) {
        deleteData(id!);
      }
    });
  }

  void getData() async {
    log("detail pesanan get data");
    isLoading.value = true;
    detail.value = {};
    service.getDetailData(id!).then((value) {
      detail.value = value;
    }).catchError((error, stackTrace) {
      showInfoDialog("Gagal", "Menampilkan Data $error");
    }).whenComplete(() {
      isLoading.value = false;
    });

    log(detail.value!.toString());
  }

  void deleteData(String id) async {
    service.deleteData(id).then((value) {
      removeTopic(id); // TODO
      Navigator.pop(context);
      showInfoDialog("Berhasil", "Menghapus Data");
    }).catchError((error, stackTrace) {
      Navigator.pop(context);
      showInfoDialog("Gagal", "Menghapus Data $error");
    });
    // await service.deleteData(id).then((value) async {
    //   await removeTopic(id);
    //   Get.back();
    //   showInfoDialog("Berhasil", "Menghapus Data");
    // }).catchError((error, stackTrace) {
    //   Get.back();
    //   showInfoDialog("Gagal", "Menghapus Data $error");
    // });
  }

  Future<void> removeTopic(String id) async {
    //remove topic from user
    final UserService userService = UserService();
    await userService.removeTopic(detail.value?["pemesan"]["id"], id);

    //notifikasi
    for (var i = 0; i < detail.value?["progress"].length; i++) {
      await userService.removeTopic(
          detail.value?["progress"][i]["pekerja"]["id"], id);
    }
  }
}
