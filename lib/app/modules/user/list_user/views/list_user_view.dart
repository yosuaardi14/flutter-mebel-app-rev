import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_card.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_drawer.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/add_user/views/add_user_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/detail_user/bindings/detail_user_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/detail_user/views/detail_user_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/list_user/controllers/list_user_controller.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';


class ListUserView extends GetView<ListUserController> {
  const ListUserView({Key? key}) : super(key: key);

  void onTambahUser() async {
    await Get.toNamed(Routes.ADD_USER)?.then((_) {
      controller.listData();
    });
  }

  void onDetailUser(String id) async {
    await Get.to(() => DetailUserView(id: id), binding: DetailUserBinding())
        ?.then((_) {
      controller.listData();
    });
  }

  void onEditUser(String id) {
    Get.to(() => AddUserView(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar User'),
          centerTitle: true,
        ),
        drawer: const CustomDrawer(no: 2),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: onTambahUser,
          child: const Icon(Icons.add),
        ),
        body: SizedBox(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.listData();
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                GetBuilder<ListUserController>(
                  init: controller,
                  builder: (val) => Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomTab(
                        label: "Semua",
                        color: controller.index.value == 0
                            ? Colors.red
                            : Colors.grey,
                        onTap: () {
                          controller.index(0);
                          controller.isAll(true);
                          controller.listData();
                        },
                      ),
                      CustomTab(
                        label: "Pekerja",
                        color: controller.index.value == 1
                            ? Colors.red
                            : Colors.grey,
                        onTap: () {
                          controller.index(1);
                          controller.isAll(false);
                          controller.listData();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FormBuilderTextField(
                    controller: controller.cari,
                    name: "cari",
                    onChanged: (value) {
                      controller.searchData();
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          controller.cari.text = "";
                        },
                        icon: const Icon(Icons.close),
                      ),
                      border: const OutlineInputBorder(),
                      isDense: true,
                      hintText: "Cari",
                    ),
                  ),
                ),
                Expanded(
                  child: GetBuilder<ListUserController>(
                    init: controller,
                    builder: (val) => LoaderWidget(
                      status: controller.status.value,
                      child: ListView(
                        shrinkWrap: true,
                        clipBehavior: Clip.antiAlias,
                        children: controller.cari.text != ""
                            ? [
                                ...controller.search!.map(
                                  (val) => CustomCardUser(
                                    user: val,
                                    onTap: () => onDetailUser(val["id"]),
                                  ),
                                )
                              ]
                            : [
                                ...controller.data!.map(
                                  (val) => CustomCardUser(
                                    user: val,
                                    onTap: () => onDetailUser(val["id"]),
                                  ),
                                )
                              ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
