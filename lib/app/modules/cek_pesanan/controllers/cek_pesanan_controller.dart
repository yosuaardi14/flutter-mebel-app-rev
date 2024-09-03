import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/data/services/pesanan_service.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/views/cek_pesanan_view.dart';

class CekPesananController extends BaseController<CekPesananPage> {
  @override
  Widget build(BuildContext context) => CekPesananView(state: this);

  final PesananService service = PesananService();
  final isLoading = ValueNotifier<bool>(false);
  final detail = ValueNotifier<Map<String, dynamic>?>({});

  final _formKey = GlobalKey<FormBuilderState>();
  get formKey => _formKey;

  String? id;

  void onCari() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      id = _formKey.currentState!.value["id"];
      getData();
    }
  }

  void getData() async {
    log("cek pesanan get data");
    isLoading.value = true;
    detail.value = {};
    service.getDetailData(id!).then((value) {
      detail.value = value;
    }).catchError((error, stackTrace) {
      detail.value = {};
    }).whenComplete(() {
      isLoading.value = false;
    });
  }
}
