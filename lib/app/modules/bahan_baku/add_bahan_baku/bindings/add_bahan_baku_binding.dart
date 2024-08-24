import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/add_bahan_baku/controllers/add_bahan_baku_controller.dart';
import 'package:get/get.dart';


class AddBahanBakuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddBahanBakuController>(
      () => AddBahanBakuController(),
    );
  }
}
