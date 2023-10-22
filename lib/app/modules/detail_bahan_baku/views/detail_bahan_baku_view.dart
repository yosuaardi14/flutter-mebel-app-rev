import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/detail_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_bahan_baku/bindings/add_bahan_baku_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_bahan_baku/views/add_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_bahan_baku/local_widgets/dialog_add_stok_bahan_baku.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_bahan_baku/local_widgets/histori_bahan_baku.dart';

import 'package:get/get.dart';

import '../controllers/detail_bahan_baku_controller.dart';

class DetailBahanBakuView extends GetView<DetailBahanBakuController> {
  final String? id;
  const DetailBahanBakuView({Key? key, this.id}) : super(key: key);

  void onEditBahanBaku(String id) async {
    await Get.to(() => AddBahanBakuView(id: id), binding: AddBahanBakuBinding())
        ?.then((_) {
      controller.getData(id);
    });
  }

  void tambahStokBahanBaku(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => DialogAddStokBahanBaku(bahanBaku: controller.detail!),
    ).then((_) {
      controller.getData(id!);
    });
  }

  void onDeleteBahanBaku(BuildContext context) async {
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
          title: const Text('Detail Bahan Baku'),
          centerTitle: true,
        ),
        body: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: () async => controller.getData(id!),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Expanded(
                  child: GetBuilder<DetailBahanBakuController>(
                    init: controller..getData(id!),
                    builder: (val) => ListView(
                      children: val.isLoading.value
                          ? [const Center(child: CircularProgressIndicator())]
                          : [
                              DetailCard(
                                  label: "Nama", value: val.detail!["nama"]),
                              DetailCard(
                                  label: "Harga",
                                  value:
                                      convertToIdr(val.detail!["harga"] ?? 0)),
                              DetailCard(
                                  label: "Stok",
                                  value: val.detail!["stok"].toString()),
                              DetailCard(
                                  label: "Merk", value: val.detail!["merk"]),
                              DetailCard(
                                  label: "Deskripsi",
                                  value: val.detail!["deskripsi"]),
                              HistoriBahanBaku(
                                data: controller.historiTambah,
                                plus: true,
                              ),
                              HistoriBahanBaku(
                                data: controller.historiPengunaan,
                                plus: false,
                              ),
                            ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    CustomTab(
                      label: "Tambah Stok",
                      color: Colors.blue,
                      onTap: () async {
                        tambahStokBahanBaku(context);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CustomTab(
                      label: "Ubah",
                      color: Colors.green,
                      onTap: () => onEditBahanBaku(controller.detail!["id"]),
                    ),
                    CustomTab(
                      label: "Hapus",
                      color: Colors.red,
                      onTap: () async {
                        onDeleteBahanBaku(context);
                      },
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
