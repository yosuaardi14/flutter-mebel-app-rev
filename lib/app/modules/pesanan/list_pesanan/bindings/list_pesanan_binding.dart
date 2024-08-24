import 'package:flutter_mebel_app_rev/app/modules/pesanan/list_pesanan/controllers/list_pesanan_controller.dart';
import 'package:get/get.dart';


class ListPesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListPesananController>(
      () => ListPesananController(),
    );
  }
}
