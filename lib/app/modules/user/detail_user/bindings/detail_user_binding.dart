import 'package:flutter_mebel_app_rev/app/modules/user/detail_user/controllers/detail_user_controller.dart';
import 'package:get/get.dart';


class DetailUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailUserController>(
      () => DetailUserController(),
    );
  }
}
