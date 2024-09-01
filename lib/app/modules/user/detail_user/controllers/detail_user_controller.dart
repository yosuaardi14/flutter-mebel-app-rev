// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/user_service.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/add_user/views/add_user_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/detail_user/views/detail_user_view.dart';

class DetailUserController extends BaseController<DetailUserPage> {
  @override
  Widget build(BuildContext context) => DetailUserView(state: this);

  final UserService service = UserService();
  final isLoading = ValueNotifier<bool>(false);
  final detail = ValueNotifier<Map<String, dynamic>?>({});

  String? get id => widget.id;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void onEditUser(String id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddUserPage(id: id),
      ),
    ).whenComplete(getData);
  }

  void onDeleteUser() async {
    showConfirmationDeleteDialog(context).then((value) {
      if (value) {
        deleteData(id!);
      }
    });
  }

  void getData() async {
    log("detail user get data");
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

  void deleteData(String id) async {
    service.deleteData(id).then((value) {
      Navigator.pop(context);
      showInfoDialog("Berhasil", "Menghapus Data");
    }).catchError((error, stackTrace) {
      Navigator.pop(context);
      showInfoDialog("Gagal", "Menghapus Data $error");
    });
  }
}
