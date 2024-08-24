import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/auth_service.dart';
import 'package:flutter_mebel_app_rev/app/modules/auth/views/login_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';

class LoginController extends BaseController<LoginPage> {
  @override
  Widget build(BuildContext context) => LoginView(state: this);

  //
  late final bool isPembeli;
  final formKey = GlobalKey<FormBuilderState>();

  //
  void onLogin() async {
    String password = "";
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (!isPembeli) {
        password = formKey.currentState!.value["password"];
      }
      log(password);
      await login(formKey.currentState!.value["nohp"], password, isPembeli);
    }
  }

  //view-model
  AuthService authService = AuthService();

  Future<void> login(String nohp, String pass, bool isPembeli) async {
    Map<String, dynamic>? user = {};
    await authService.login(nohp, pass, isPembeli).then((value) async {
      user = value;
      await authService.saveLoginData(user);
      showInfoDialog("Berhasil", "Login").then((_) {
        Navigator.pushReplacementNamed(context, Routes.LIST_PESANAN);
        // Get.offAllNamed(Routes.LIST_PESANAN);
      });
    }).catchError((e) {
      showInfoDialog("Gagal", "$e");
    }).whenComplete(() => log(user.toString()));
  }
}
