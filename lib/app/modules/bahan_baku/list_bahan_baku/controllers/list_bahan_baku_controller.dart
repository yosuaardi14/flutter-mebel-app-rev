import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/bahan_baku_service.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/list_bahan_baku/views/list_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/add_bahan_baku/views/add_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/detail_bahan_baku/views/detail_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';

class ListBahanBakuController extends BaseController<ListBahanBakuPage> {
  @override
  Widget build(BuildContext context) => ListBahanBakuView(state: this);

  final BahanBakuService service = BahanBakuService();
  final status = ValueNotifier<Status>(Status.none);
  bool isError = false;
  final isAll = ValueNotifier<bool>(true);
  final index = ValueNotifier<int>(0);

  TextEditingController cari = TextEditingController(text: "");
  final data = ValueNotifier<List<Map<String, dynamic>>?>([]);
  final search = ValueNotifier<List<Map<String, dynamic>>?>([]);

  void onTambahBahanBaku() async {
    Navigator.pushNamed(
      context,
      Routes.ADD_BAHAN_BAKU,
    ).whenComplete(listData);
  }

  void onDetailBahanBaku(String id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailBahanBakuPage(id: id),
      ),
    ).whenComplete(listData);
  }

  void onEditBahanBaku(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBahanBakuPage(id: id),
      ),
    ).whenComplete(listData);
  }

  void clearSearch() {
    FocusScope.of(context).unfocus();
    cari.text = "";
  }

  void onFilterBahanBaku(value) {
    if (value == 0) {
      index.value = 0;
      isAll.value = true;
      listData();
    } else if (value == 1) {
      index.value = 1;
      isAll.value = false;
      listData();
    }
  }

  @override
  void initState() {
    super.initState();
    listData();
  }

  void listData() async {
    log("list user get data");
    status.value = Status.loading;
    data.value = [];
    cari.text = "";
    service.listData(isAll.value).then((value) {
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

  void searchData(String? value) {
    search.value = [];
    if (value != "" || (value?.isNotEmpty ?? false)) {
      search.value?.addAll(
        data.value!.where(
          (element) => searchItems(element["nama"], value ?? ""),
        ),
      );
    }
  }
}
