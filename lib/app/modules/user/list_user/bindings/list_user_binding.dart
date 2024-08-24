import 'package:flutter_mebel_app_rev/app/modules/user/list_user/controllers/list_user_controller.dart';
import 'package:get/get.dart';


class ListUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListUserController>(
      () => ListUserController(),
    );
  }
}
