import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/detail_pesanan/local_widgets/informasi_pesanan_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/detail_pesanan/local_widgets/pemesan_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/detail_pesanan/local_widgets/progress_pesanan_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/detail_pesanan/controllers/detail_pesanan_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/detail_pesanan/local_widgets/bahan_baku_card.dart';

class DetailPesananPage extends StatefulWidget {
  final String? id;
  const DetailPesananPage({super.key, this.id});

  @override
  State<DetailPesananPage> createState() => DetailPesananController();
}

class DetailPesananView extends StatelessWidget {
  final DetailPesananController state;
  const DetailPesananView({super.key, required this.state});

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
                          if (detail?.isEmpty ?? false) {
                            return const SizedBox();
                          }
                          return ListView(
                            children: [
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
                                        child: Text("${detail?["id"] ?? ""}",
                                            maxLines: 4),
                                      ),
                                      TextButton(
                                        child: const Text("SALIN"),
                                        onPressed: () {
                                          copyToClipboard(
                                            label: "ID",
                                            value: detail?["id"],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InformasiPesananCard(
                                title: "Informasi Pesanan",
                                data: detail?["info"],
                              ),
                              PemesanCard(
                                title: "Pemesan",
                                data: detail?["pemesan"],
                              ),
                              BahanBakuCard(
                                title: "Bahan Baku",
                                data: detail?["bahanBaku"],
                              ),
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
                                      ...detail?["progress"].map(
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
                                      "${detail?["foto"].length == 0 ? "Belum Ada " : ""}Foto",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              ...detail?["foto"].map((e) => imageCard(e)),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (!isPembeli())
                        CustomTab(
                          label: "Ubah",
                          color: Colors.green,
                          onTap: () => state.onEditPesanan(state.id!),
                        ),
                      if (isAdmin())
                        CustomTab(
                          label: "Hapus",
                          color: Colors.red,
                          onTap: state.onDeletePesanan,
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
