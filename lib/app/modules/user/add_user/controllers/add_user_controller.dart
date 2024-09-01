// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/user_service.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/add_user/views/add_user_view.dart';

class AddUserController extends BaseController<AddUserPage> {
  @override
  Widget build(BuildContext context) => AddUserView(state: this);

  final UserService service = UserService();
  final detail = ValueNotifier<Map<String, dynamic>?>({});
  final isLoading = ValueNotifier<bool>(false);
  String? get id => widget.id;

  final _formKey = GlobalKey<FormBuilderState>();
  get formKey => _formKey;

  String role = "";

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
    service.findDuplicate("nohp", data["nohp"]).then((value) {
      if (value == "") {
        service.addData(data).then((value) {
          Navigator.pop(context);
          showInfoDialog("Berhasil", "Menambahkan Data");
        }).catchError((error, stackTrace) {
          Navigator.pop(context);
          showInfoDialog("Gagal", "Menambahkan Data $error");
        });
      } else {
        showInfoDialog("Gagal", "Menambahkan Data Nomor HP telah terdaftar");
        showOverlay.value = false;
      }
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
    log("add user get data");
    isLoading.value = true;
    detail.value = {};
    service.getData(id!).then((value) {
      detail.value = value;
      role = detail.value?["role"] ?? "";
    }).catchError((error, stackTrace) {
      showInfoDialog("Gagal", "Menampilkan Data $error");
    }).whenComplete(() {
      isLoading.value = false;
    });
  }
}
