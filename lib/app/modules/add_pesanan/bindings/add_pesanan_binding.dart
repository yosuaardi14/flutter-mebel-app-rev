import 'package:get/get.dart';

import '../controllers/add_pesanan_controller.dart';

class AddPesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPesananController>(
      () => AddPesananController(),
    );
  }
}
