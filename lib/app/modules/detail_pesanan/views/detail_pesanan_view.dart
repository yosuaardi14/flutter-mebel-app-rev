import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/bindings/add_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/views/add_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_pesanan/local_widgets/informasi_pesanan_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_pesanan/local_widgets/pemesan_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_pesanan/local_widgets/bahan_baku_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_pesanan/local_widgets/progress_pesanan_card.dart';

import 'package:get/get.dart';

import '../controllers/detail_pesanan_controller.dart';

class DetailPesananView extends GetView<DetailPesananController> {
  final String? id;
  const DetailPesananView({Key? key, this.id}) : super(key: key);

  void onEditPesanan(String id) async {
    await Get.to(() => AddPesananView(id: id), binding: AddPesananBinding())
        ?.then((_) {
      controller.getData(id);
    });
  }

  void onDeletePesanan(BuildContext context) async {
    bool hasil = await showConfirmationDeleteDialog(context);
    if (hasil) {
      controller.deleteData(controller.detail!["id"]);
    }
  }

  Widget imageCard(String url) {
    return Card(
      elevation: 5,
      child: Image.network(
        url,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: Text("Loading"),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Pesanan'),
          centerTitle: true,
        ),
        body: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: () async => controller.getData(id!),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Expanded(
                  child: GetBuilder<DetailPesananController>(
                    init: controller..getData(id!),
                    builder: (val) => ListView(
                      children: val.isLoading.value
                          ? [const Center(child: CircularProgressIndicator())]
                          : [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Kode: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                            "${val.detail?["id"] ?? ""}",
                                            maxLines: 4),
                                      ),
                                      TextButton(
                                        child: const Text("SALIN"),
                                        onPressed: () {
                                          copyToClipboard(
                                            label: "ID",
                                            value: val.detail?["id"],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InformasiPesananCard(
                                  title: "Informasi Pesanan",
                                  data: val.detail!["info"]),
                              PemesanCard(
                                  title: "Pemesan",
                                  data: val.detail!["pemesan"]),
                              BahanBakuCard(
                                  title: "Bahan Baku",
                                  data: val.detail!["bahanBaku"]),
                              Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                      child: Column(
                                    children: [
                                      const Text(
                                        "Progress Pesanan",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      const SizedBox(height: 20),
                                      ...val.detail!["progress"].map(
                                        (e) => ProgressPesananCard(data: e),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                              Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      (val.detail!["foto"].length == 0
                                              ? "Belum Ada "
                                              : "") +
                                          "Foto",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              ...val.detail!["foto"].map((e) => imageCard(e)),
                            ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (!isPembeli())
                      CustomTab(
                        label: "Ubah",
                        color: Colors.green,
                        onTap: () => onEditPesanan(controller.detail!["id"]),
                      ),
                    if (isAdmin())
                      CustomTab(
                        label: "Hapus",
                        color: Colors.red,
                        onTap: () async {
                          onDeletePesanan(context);
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
