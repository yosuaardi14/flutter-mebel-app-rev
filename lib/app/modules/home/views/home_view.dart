import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_button.dart';
import 'package:flutter_mebel_app_rev/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/login/bindings/login_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/login/views/login_view.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';

import 'package:get/get.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  void onLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  void onLoginPembeli() {
    Get.to(() => LoginView(isPembeli: true), binding: LoginBinding());
  }

  void onCekPesanan() {
    Get.toNamed(Routes.CEK_PESANAN);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(label: "MASUK", onPressed: onLogin),
              const SizedBox(height: 20),
              CustomButton(
                  label: "MASUK SEBAGAI PEMBELI", onPressed: onLoginPembeli),
              const SizedBox(height: 20),
              CustomButton(label: "CEK PESANAN", onPressed: onCekPesanan),
            ],
          ),
        ),
      ),
    );
  }
}
