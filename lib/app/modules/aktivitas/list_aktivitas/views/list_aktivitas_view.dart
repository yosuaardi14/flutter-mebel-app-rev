import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_card.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_drawer.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/bindings/add_aktivitas_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/views/add_aktivitas_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/list_aktivitas/controllers/list_aktivitas_controller.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';

import 'package:get/get.dart';

class ListAktivitasView extends GetView<ListAktivitasController> {
  const ListAktivitasView({Key? key}) : super(key: key);

  void onTambahPesanan() async {
    await Get.toNamed(Routes.ADD_ACTIVITY)?.then((_) {
      controller.listData();
    });
  }

  void onEditAktivitas(String id) async {
    await Get.to(() => AddAktivitasView(id: id), binding: AddAktivitasBinding())
        ?.then((_) {
      controller.listData();
    });
  }

  void onEditPesanan(String id) {
    Get.to(() => AddAktivitasView(id: id), binding: AddAktivitasBinding());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Aktivitas'),
          centerTitle: true,
        ),
        drawer: const CustomDrawer(no: 4),
        floatingActionButtonLocation:
            isAdmin() ? FloatingActionButtonLocation.centerFloat : null,
        floatingActionButton: isAdmin()
            ? FloatingActionButton(
                onPressed: onTambahPesanan,
                child: const Icon(Icons.add),
              )
            : null,
        body: SizedBox(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.listData();
            },
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // GetBuilder<ListAktivitasController>(
              //   init: controller,
              //   builder: (val) => Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       CustomTab(
              //         label: "Hari Ini",
              //         color: controller.index.value == 0
              //             ? Colors.red
              //             : Colors.grey,
              //         onTap: () {
              //           controller.index(0);
              //           controller.type("today");
              //           controller.listData();
              //         },
              //       ),
              //       CustomTab(
              //         label: "Belum Selesai",
              //         color: controller.index.value == 1
              //             ? Colors.red
              //             : Colors.grey,
              //         onTap: () {
              //           controller.index(1);
              //           controller.type("belumSelesai");
              //           controller.listData();
              //         },
              //       ),
              //       CustomTab(
              //         label: "Selesai",
              //         color: controller.index.value == 2
              //             ? Colors.red
              //             : Colors.grey,
              //         onTap: () {
              //           controller.index(2);
              //           controller.type("selesai");
              //           controller.listData();
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 4),
              //   child: FormBuilderTextField(
              //     controller: controller.cari,
              //     name: "cari",
              //     onChanged: (value) {
              //       controller.searchData();
              //     },
              //     decoration: InputDecoration(
              //       prefixIcon: const Icon(Icons.search),
              //       suffixIcon: IconButton(
              //         onPressed: () {
              //           controller.cari.text = "";
              //         },
              //         icon: const Icon(Icons.close),
              //       ),
              //       errorMaxLines: 2,
              //       border: const OutlineInputBorder(),
              //       isDense: true,
              //       hintText: "Cari",
              //     ),
              //   ),
              // ),
              Expanded(
                child: GetBuilder<ListAktivitasController>(
                  init: controller,
                  builder: (val) => LoaderWidget(
                    status: controller.status.value,
                    child: ListView(
                      children: [
                        ...controller.data!.map(
                          (val) => CustomCardAktivitas(
                            aktivitas: val,
                            onTap: () => onEditAktivitas(val["id"]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
