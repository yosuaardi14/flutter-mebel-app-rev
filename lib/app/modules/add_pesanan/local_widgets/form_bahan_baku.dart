import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/bahan_baku_service.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/controllers/add_pesanan_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/local_widgets/dialog_add_bahan_baku.dart';
import 'package:get/get.dart';

class FormBahanBaku extends StatefulWidget {
  final String? id;

  const FormBahanBaku({Key? key, this.id}) : super(key: key);

  @override
  State<FormBahanBaku> createState() => _FormBahanBakuState();
}

class _FormBahanBakuState extends State<FormBahanBaku> {
  List<Widget> children = [];
  List<Widget> child = [];
  final controller = Get.find<AddPesananController>();
  @override
  void initState() {
    super.initState();
    children.add(
      ElevatedButton(onPressed: addBahanBaku, child: const Text("TAMBAH")),
    );
    refresh();
  }

  void addBahanBaku() async {
    Map<String, dynamic>? hasil = await showDialog(
      context: context,
      builder: (ctx) => DialogAddBahanBaku(),
      barrierDismissible: false,
    );

    if (hasil != null) {
      controller.bahanBaku[hasil["id"]] = hasil["jumlah"];
    }
    refresh();
  }

  Future<List<Widget>> getList() async {
    var child = <Widget>[];
    for (var e in controller.bahanBaku.entries) {
      var bahanBakuService = BahanBakuService();
      Map<String, dynamic>? hasil = await bahanBakuService.getData(e.key);
      hasil?["jumlah"] = e.value;
      log(hasil.toString());
      child.add(infoCard(hasil!));
    }
    return child;
  }

  void refresh() async {
    await getList().then((value) => child = value).whenComplete(() {
      setState(() {
        children.replaceRange(1, children.length, child);
      });
    });
  }

  Widget infoCard(Map<String, dynamic> hasil) {
    return Card(
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(hasil["nama"]),
        ),
        title: Text(hasil["jumlah"].toString()),
        trailing: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () async {
              bool confirm = await showConfirmationDeleteDialog(context);
              if (confirm) {
                setState(() {
                  controller.bahanBaku
                      .removeWhere((key, value) => key == hasil["id"]);
                  refresh();
                });
              }
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
