import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/auth_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/pesanan_service.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/detail_pesanan/views/detail_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/list_pesanan/views/list_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';

class ListPesananController extends BaseController<ListPesananPage> {
  @override
  Widget build(BuildContext context) => ListPesananView(state: this);

  final PesananService service = PesananService();
  final status = ValueNotifier<Status>(Status.none);
  bool isError = false;

  final type = ValueNotifier<String>("today");
  final index = ValueNotifier<int>(0);
  TextEditingController cari = TextEditingController(text: "");
  final data = ValueNotifier<List<Map<String, dynamic>>?>([]);
  final search = ValueNotifier<List<Map<String, dynamic>>?>([]);

  final List<String> typeList = ["Hari Ini", "Belum Selesai", "Selesai"];

  void onTambahPesanan() async {
    Navigator.pushNamed(
      context,
      Routes.ADD_PESANAN,
    ).whenComplete(listData);
  }

  void onDetailPesanan(String id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPesananPage(id: id),
      ),
    ).whenComplete(listData);
  }

  void onEditPesanan(String id) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AddPesananPage(id: id),
    //   ),
    // ).whenComplete(listData);
  }

  void clearSearch() {
    FocusScope.of(context).unfocus();
    cari.text = "";
  }

  void onFilterPesanan(value) {
    if (value == 0) {
      index.value = 0;
      type.value = "today";
      listData();
    } else if (value == 1) {
      index.value = 1;
      type.value = "belumSelesai";
      listData();
    } else if (value == 2) {
      index.value = 2;
      type.value = "selesai";
      listData();
    }
  }

  @override
  void initState() {
    super.initState();
    listData();
  }

  void listData() async {
    log("list pesanan get data");
    status.value = Status.loading;
    data.value = [];
    cari.text = "";
    service.listData(type.value).then(
      (value) {
        data.value = value;
        if (AuthService.userData["role"] == "Pekerja") {
          List<Map<String, dynamic>> temp = [];
          for (var item in data.value!) {
            for (var i = 0; i < item["progress"].length; i++) {
              if (item["progress"][i]["pekerja"] ==
                  AuthService.userData["id"]) {
                temp.add(item);
                break;
              }
            }
          }
          data.value = temp;
        } else if (AuthService.userData["role"] == "Pembeli") {
          List<Map<String, dynamic>> temp = [];
          for (var item in data.value!) {
            if (item["pemesan"]["id"] == AuthService.userData["id"]) {
              temp.add(item);
            }
          }
          data.value = temp;
        }
      },
    ).catchError((e, stackTree) {
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

  void searchData(String? value) {
    search.value = [];
    if (value != "" || (value?.isNotEmpty ?? false)) {
      search.value?.addAll(
        data.value!.where(
          (element) => searchItems(element["info"]["nama"], value ?? ""),
        ),
      );
    }
  }
}
