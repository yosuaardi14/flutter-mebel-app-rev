import 'package:get/get.dart';

import '../controllers/list_pesanan_controller.dart';

class ListPesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListPesananController>(
      () => ListPesananController(),
    );
  }
}
