import 'package:flutter_mebel_app_rev/app/modules/pesanan/detail_pesanan/controllers/detail_pesanan_controller.dart';
import 'package:get/get.dart';


class DetailPesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPesananController>(
      () => DetailPesananController(),
    );
  }
}
