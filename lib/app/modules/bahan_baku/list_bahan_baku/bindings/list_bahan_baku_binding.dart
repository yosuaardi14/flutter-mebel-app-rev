import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/list_bahan_baku/controllers/list_bahan_baku_controller.dart';
import 'package:get/get.dart';


class ListBahanBakuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListBahanBakuController>(
      () => ListBahanBakuController(),
    );
  }
}
