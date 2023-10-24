import 'package:flutter_mebel_app_rev/app/modules/aktivitas/list_aktivitas/controllers/list_aktivitas_controller.dart';
import 'package:get/get.dart';


class ListAktivitasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListAktivitasController>(
      () => ListAktivitasController(),
    );
  }
}
