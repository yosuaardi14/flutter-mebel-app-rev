import 'package:get/get.dart';

import '../controllers/add_aktivitas_controller.dart';

class AddAktivitasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAktivitasController>(
      () => AddAktivitasController(),
    );
  }
}
