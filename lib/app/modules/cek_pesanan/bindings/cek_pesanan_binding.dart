import 'package:get/get.dart';

import '../controllers/cek_pesanan_controller.dart';

class CekPesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CekPesananController>(
      () => CekPesananController(),
    );
  }
}
