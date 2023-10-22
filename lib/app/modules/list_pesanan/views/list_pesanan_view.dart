import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_card.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_drawer.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/bindings/add_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/views/add_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_pesanan/bindings/detail_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_pesanan/views/detail_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';

import '../controllers/list_pesanan_controller.dart';

class ListPesananView extends GetView<ListPesananController> {
  const ListPesananView({Key? key}) : super(key: key);

  void onTambahPesanan() async {
    await Get.toNamed(Routes.ADD_PESANAN)?.then((_) {
      controller.listData();
    });
  }

  void onDetailPesanan(String id) async {
    await Get.to(() => DetailPesananView(id: id),
            binding: DetailPesananBinding())
        ?.then((_) {
      controller.listData();
    });
  }

  void onEditPesanan(String id) {
    Get.to(() => AddPesananView(id: id), binding: AddPesananBinding());
  }

  @override
  Widget build(BuildContext context) {
    // List<Map<String, dynamic>> progress = [
    //   {"tahap": "pengukuran", "waktu": 420, "persentase": 100},
    //   {"tahap": "pengukuran", "waktu": 210, "persentase": 100},
    //   {"tahap": "pengukuran", "waktu": 60, "persentase": 100},
    //   {"tahap": "pemotongan", "waktu": 210, "persentase": 100},
    //   {"tahap": "perakitan", "waktu": 60, "persentase": 100},
    //   {"tahap": "pemasangan", "waktu": 60, "persentase": 100},
    //   {"tahap": "pemasangan", "waktu": 60, "persentase": 50},
    // ];
    // log(getTanggalPerkiraanSelesaiTahap(progress, "14-01-2023").toString());
    // log(getPresentaseProgressNew(progress).toString());
    // log("Pengukuran: " +
    //     getPresentaseProgressTahap(progress, "pengukuran").toString());
    // log("Pemotongan: " +
    //     getPresentaseProgressTahap(progress, "pemotongan").toString());
    // log("Perakitan: " +
    //     getPresentaseProgressTahap(progress, "perakitan").toString());
    // log("Pemasangan: " +
    //     getPresentaseProgressTahap(progress, "pemasangan").toString());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Pesanan'),
          centerTitle: true,
        ),
        drawer: const CustomDrawer(no: 0),
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
              GetBuilder<ListPesananController>(
                init: controller,
                builder: (val) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTab(
                      label: "Hari Ini",
                      color: controller.index.value == 0
                          ? Colors.red
                          : Colors.grey,
                      onTap: () {
                        controller.index(0);
                        controller.type("today");
                        controller.listData();
                      },
                    ),
                    CustomTab(
                      label: "Belum Selesai",
                      color: controller.index.value == 1
                          ? Colors.red
                          : Colors.grey,
                      onTap: () {
                        controller.index(1);
                        controller.type("belumSelesai");
                        controller.listData();
                      },
                    ),
                    CustomTab(
                      label: "Selesai",
                      color: controller.index.value == 2
                          ? Colors.red
                          : Colors.grey,
                      onTap: () {
                        controller.index(2);
                        controller.type("selesai");
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
                child: GetBuilder<ListPesananController>(
                  init: controller,
                  builder: (val) => ListView(
                    children: controller.isLoading.value
                        ? [
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          ]
                        : controller.cari.text != ""
                            ? [
                                ...controller.search!.map(
                                  (val) => CustomCardPesanan(
                                    pesanan: val,
                                    onTap: () => onDetailPesanan(val["id"]),
                                  ),
                                )
                              ]
                            : [
                                ...controller.data!.map(
                                  (val) => CustomCardPesanan(
                                    pesanan: val,
                                    onTap: () => onDetailPesanan(val["id"]),
                                  ),
                                )
                              ],
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
