import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/controllers/add_aktivitas_controller.dart';
import 'package:get/get.dart';


class AddAktivitasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAktivitasController>(
      () => AddAktivitasController(),
    );
  }
}
