import 'package:get/get.dart';

import '../controllers/list_user_controller.dart';

class ListUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListUserController>(
      () => ListUserController(),
    );
  }
}
