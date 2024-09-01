import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/data/services/auth_service.dart';
import 'package:flutter_mebel_app_rev/app/modules/auth/views/login_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';

class LoginController extends BaseController<LoginPage> {
  @override
  Widget build(BuildContext context) => LoginView(state: this);

  //
  bool isPembeli = false;
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
    showOverlay.value = true;
    Map<String, dynamic>? user = {};
    authService.login(nohp, pass, isPembeli).then((value) async {
      user = value;
      await authService.saveLoginData(user);
      showInfoDialog(
        title: "Berhasil",
        content: "Login",
        onPressed: () =>
            Navigator.pushReplacementNamed(context, Routes.LIST_PESANAN),
      );
    }).catchError((e) {
      showInfoDialog(
        title: "Gagal",
        content: "$e",
      );
    }).whenComplete(() {
      log(user.toString());
      showOverlay.value = false;
    });
  }
}
