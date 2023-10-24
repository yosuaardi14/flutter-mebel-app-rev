import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller.dart';
import 'package:get/get.dart';


class AddPesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPesananController>(
      () => AddPesananController(),
    );
  }
}
