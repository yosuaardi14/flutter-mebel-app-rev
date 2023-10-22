import 'package:get/get.dart';

import '../controllers/list_bahan_baku_controller.dart';

class ListBahanBakuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListBahanBakuController>(
      () => ListBahanBakuController(),
    );
  }
}
