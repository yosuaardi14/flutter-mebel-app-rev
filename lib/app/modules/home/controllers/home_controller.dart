import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/home/views/home_view.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';

class HomeController extends BaseController<HomePage> {
  @override
  Widget build(BuildContext context) => HomeView(state: this);

  void onLogin() {
    Navigator.pushNamed(context, Routes.LOGIN);
  }

  void onLoginPembeli() {
    Navigator.pushNamed(context, Routes.LOGIN, arguments: true);
  }

  void onCekPesanan() {
    Navigator.pushNamed(context, Routes.CEK_PESANAN);
  }
}
