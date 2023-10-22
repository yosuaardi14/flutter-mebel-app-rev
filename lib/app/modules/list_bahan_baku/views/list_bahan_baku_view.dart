import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_card.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_drawer.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_bahan_baku/views/add_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_bahan_baku/bindings/detail_bahan_baku_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_bahan_baku/views/detail_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';

import '../controllers/list_bahan_baku_controller.dart';

class ListBahanBakuView extends GetView<ListBahanBakuController> {
  const ListBahanBakuView({Key? key}) : super(key: key);

  void onTambahBahanBaku() async {
    await Get.toNamed(Routes.ADD_BAHAN_BAKU)?.then((_) {
      controller.listData();
    });
  }

  void onDetailBahanBaku(String id) async {
    await Get.to(() => DetailBahanBakuView(id: id),
            binding: DetailBahanBakuBinding())
        ?.then((_) {
      controller.listData();
    });
  }

  void onEditBahanBaku(String id) {
    Get.to(() => AddBahanBakuView(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Bahan Baku'),
          centerTitle: true,
        ),
        drawer: const CustomDrawer(no: 1),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: onTambahBahanBaku,
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
                GetBuilder<ListBahanBakuController>(
                  init: controller,
                  builder: (val) => Row(
                    mainAxisSize: MainAxisSize.min,
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
                        label: "Kosong",
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
                      errorMaxLines: 2,
                      border: const OutlineInputBorder(),
                      isDense: true,
                      hintText: "Cari",
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: GetBuilder<ListBahanBakuController>(
                    init: controller,
                    builder: (val) => LoaderWidget(
                      status: controller.status.value,
                      child: ListView(
                        children: controller.cari.text != ""
                            ? [
                                ...controller.search!.map(
                                  (val) => CustomCardBahanBaku(
                                    bahanBaku: val,
                                    onTap: () => onDetailBahanBaku(val["id"]),
                                  ),
                                )
                              ]
                            : [
                                ...controller.data!.map(
                                  (val) => CustomCardBahanBaku(
                                    bahanBaku: val,
                                    onTap: () => onDetailBahanBaku(val["id"]),
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
