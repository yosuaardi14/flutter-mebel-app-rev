import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/detail_bahan_baku/controllers/detail_bahan_baku_controller.dart';
import 'package:get/get.dart';


class DetailBahanBakuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBahanBakuController>(
      () => DetailBahanBakuController(),
    );
  }
}
