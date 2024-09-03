// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/bahan_baku_service.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/add_bahan_baku/views/add_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';

class AddBahanBakuController extends BaseController<AddBahanBakuPage> {
  @override
  Widget build(BuildContext context) => AddBahanBakuView(state: this);

  final BahanBakuService service = BahanBakuService();
  final detail = ValueNotifier<Map<String, dynamic>?>({});
  final isLoading = ValueNotifier<bool>(false);
  String? get id => widget.id;

  final _formKey = GlobalKey<FormBuilderState>();
  get formKey => _formKey;

  void simpan() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      Future<bool> hasil = id == null
          ? showConfirmationAddDialog(context)
          : showConfirmationEditDialog(context);
      hasil.then((value) {
        if (value) {
          _formKey.currentState!.save();
          simpanData(id, _formKey.currentState!.value);
        }
      });
    }
  }

  void simpanData(String? id, Map<String, dynamic> data) {
    showOverlay.value = true;
    if (id == null) {
      tambahData(data);
    } else {
      editData(id, data);
    }
  }

  void tambahData(Map<String, dynamic> data) async {
    Map<String, dynamic> newData = {};
    newData.addAll(data);
    if (data["stok"] == 0) {
      newData["histori-tambah"] = [];
    } else {
      newData["histori-tambah"] = [
        {
          "tanggal": dateTimeToString(DateTime.now()),
          "jumlah": data["stok"],
          "harga": data["harga"]
        }
      ];
    }

    service.addData(newData).then((value) {
      Navigator.pop(context);
      showInfoDialog("Berhasil", "Menambahkan Data");
    }).catchError((error, stackTrace) {
      Navigator.pop(context);
      showInfoDialog("Gagal", "Menambahkan Data $error");
    });
  }

  void editData(String id, Map<String, dynamic> data) async {
    service.updateData(id, data).then((value) {
      Navigator.pop(context);
      showInfoDialog("Berhasil", "Mengubah Data");
    }).catchError((error, stackTrace) {
      Navigator.pop(context);
      showInfoDialog("Gagal", "Mengubah Data $error");
    });
  }

  void getData() async {
    log("add bahan baku get data");
    isLoading.value = true;
    detail.value = {};
    service.getData(id!).then((value) {
      detail.value = value;
    }).catchError((error, stackTrace) {
      showInfoDialog("Gagal", "Menampilkan Data $error");
    }).whenComplete(() {
      isLoading.value = false;
    });
  }
}
