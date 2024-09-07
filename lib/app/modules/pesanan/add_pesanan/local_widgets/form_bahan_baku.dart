import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/data/services/bahan_baku_service.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller_v2.dart';

class FormBahanBaku extends StatefulWidget {
  final AddPesananControllerV2 state;

  const FormBahanBaku({super.key, required this.state});

  @override
  State<FormBahanBaku> createState() => _FormBahanBakuState();
}

class _FormBahanBakuState extends State<FormBahanBaku> {
  List<Widget> children = [];
  List<Widget> child = [];
  
  @override
  void initState() {
    super.initState();
    children.add(
      ElevatedButton.icon(
        onPressed: addBahanBaku,
        icon: const Icon(Icons.add),
        label: const Text("TAMBAH"),
      ),
    );
    refresh();
  }

  void addBahanBaku() async {
    widget.state.showDialogAddBahanBaku(refresh);
  }

  Future<List<Widget>> getList() async {
    var child = <Widget>[];
    for (var e in widget.state.bahanBaku.entries) {
      var bahanBakuService = BahanBakuService();
      Map<String, dynamic>? hasil = await bahanBakuService.getData(e.key);
      hasil?["jumlah"] = e.value;
      log(hasil.toString());
      child.add(infoCard(hasil!));
    }
    return child;
  }

  void refresh() async {
    getList().then((value) => child = value).whenComplete(() {
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
          onPressed: () {
            widget.state.deleteBahanBaku(hasil["id"], refresh);
          },
        ),
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
