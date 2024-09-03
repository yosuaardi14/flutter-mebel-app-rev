import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/detail_card.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/detail_bahan_baku/controllers/detail_bahan_baku_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/detail_bahan_baku/local_widgets/histori_bahan_baku.dart';

class DetailBahanBakuPage extends StatefulWidget {
  final String? id;
  const DetailBahanBakuPage({super.key, this.id});

  @override
  State<DetailBahanBakuPage> createState() => DetailBahanBakuController();
}

class DetailBahanBakuView extends StatelessWidget {
  final DetailBahanBakuController state;
  const DetailBahanBakuView({super.key, required this.state});

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
              onRefresh: () async => state.getData(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: LoaderBooleanNotifierWidget(
                      isLoading: state.isLoading,
                      child: ValueListenableBuilder(
                        valueListenable: state.detail,
                        builder: (context, detail, child) {
                          return ListView(
                            children: [
                              DetailCard(
                                label: "Nama",
                                value: detail?["nama"],
                              ),
                              DetailCard(
                                label: "Harga",
                                value: convertToIdr(detail?["harga"] ?? 0),
                              ),
                              DetailCard(
                                label: "Stok",
                                value: detail?["stok"].toString(),
                              ),
                              DetailCard(
                                label: "Merk",
                                value: detail?["merk"],
                              ),
                              DetailCard(
                                label: "Deskripsi",
                                value: detail?["deskripsi"],
                              ),
                              ValueListenableBuilder(
                                valueListenable: state.historiTambah,
                                builder: (context, value, child) {
                                  return HistoriBahanBaku(
                                    data: value,
                                    plus: true,
                                  );
                                },
                              ),
                              ValueListenableBuilder(
                                valueListenable: state.historiPengunaan,
                                builder: (context, value, child) {
                                  return HistoriBahanBaku(
                                    data: value,
                                    plus: false,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: GetBuilder<DetailBahanBakuController>(
                  //     init: controller..getData(id!),
                  //     builder: (val) => ListView(
                  //       children: val.isLoading.value
                  //           ? [const Center(child: CircularProgressIndicator())]
                  //           : [
                  //               DetailCard(
                  //                   label: "Nama", value: val.detail!["nama"]),
                  //               DetailCard(
                  //                   label: "Harga",
                  //                   value:
                  //                       convertToIdr(val.detail!["harga"] ?? 0)),
                  //               DetailCard(
                  //                   label: "Stok",
                  //                   value: val.detail!["stok"].toString()),
                  //               DetailCard(
                  //                   label: "Merk", value: val.detail!["merk"]),
                  //               DetailCard(
                  //                   label: "Deskripsi",
                  //                   value: val.detail!["deskripsi"]),
                  //               HistoriBahanBaku(
                  //                 data: controller.historiTambah,
                  //                 plus: true,
                  //               ),
                  //               HistoriBahanBaku(
                  //                 data: controller.historiPengunaan,
                  //                 plus: false,
                  //               ),
                  //             ],
                  //     ),
                  //   ),
                  // ),
                  Row(
                    children: [
                      CustomTab(
                        label: "Tambah Stok",
                        color: Colors.blue,
                        onTap: () async {
                          state.tambahStokBahanBaku();
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
                        onTap: () => state.onEditBahanBaku(state.id!),
                      ),
                      CustomTab(
                        label: "Hapus",
                        color: Colors.red,
                        onTap: state.onDeleteBahanBaku,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
