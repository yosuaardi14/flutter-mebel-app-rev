import 'package:get/get.dart';

import '../controllers/add_bahan_baku_controller.dart';

class AddBahanBakuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddBahanBakuController>(
      () => AddBahanBakuController(),
    );
  }
}
