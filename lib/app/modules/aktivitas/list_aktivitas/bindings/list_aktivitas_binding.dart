import 'package:get/get.dart';

import '../controllers/list_aktivitas_controller.dart';

class ListAktivitasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListAktivitasController>(
      () => ListAktivitasController(),
    );
  }
}
