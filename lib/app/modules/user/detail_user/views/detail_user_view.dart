import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/detail_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/add_user/bindings/add_user_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/add_user/views/add_user_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/detail_user/controllers/detail_user_controller.dart';

import 'package:get/get.dart';


class DetailUserView extends GetView<DetailUserController> {
  final String? id;
  const DetailUserView({Key? key, this.id}) : super(key: key);

  void onEditUser(String id) async {
    await Get.to(() => AddUserView(id: id), binding: AddUserBinding())
        ?.then((_) {
      controller.getData(id);
    });
  }

  void onDeleteUser(BuildContext context) async {
    bool hasil = await showConfirmationDeleteDialog(context);
    if (hasil) {
      controller.deleteData(controller.detail!["id"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail User'),
          centerTitle: true,
        ),
        body: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: () async => controller.getData(id!),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Expanded(
                  child: GetBuilder<DetailUserController>(
                    init: controller..getData(id!),
                    builder: (val) => ListView(
                      children: val.isLoading.value
                          ? [const Center(child: CircularProgressIndicator())]
                          : [
                              DetailCard(
                                  label: "Nama Lengkap",
                                  value: val.detail!["nama"]),
                              DetailCard(
                                  label: "No HP", value: val.detail!["nohp"]),
                              DetailCard(
                                  label: "Role", value: val.detail!["role"]),
                              DetailCard(
                                  label: "Alamat",
                                  value: val.detail!["alamat"]),
                            ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    CustomTab(
                      label: "Ubah",
                      color: Colors.green,
                      onTap: () => onEditUser(controller.detail!["id"]),
                    ),
                    CustomTab(
                      label: "Hapus",
                      color: Colors.red,
                      onTap: () => onDeleteUser(context),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
