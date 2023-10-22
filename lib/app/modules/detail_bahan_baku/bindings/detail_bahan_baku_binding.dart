import 'package:get/get.dart';

import '../controllers/detail_bahan_baku_controller.dart';

class DetailBahanBakuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBahanBakuController>(
      () => DetailBahanBakuController(),
    );
  }
}
