import 'dart:developer';

import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/auth_service.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  AuthService authService = AuthService();

  Future<void> login(String nohp, String pass, bool isPembeli) async {
    Map<String, dynamic>? user = {};
    await authService.login(nohp, pass, isPembeli).then((value) async {
      user = value;
      await authService.saveLoginData(user);
      showInfoDialog("Berhasil", "Login").then((_) {
        Get.offAllNamed(Routes.LIST_PESANAN);
      });
    }).catchError((e) {
      showInfoDialog("Gagal", "$e");
    }).whenComplete(() => log(user.toString()));
  }
}
