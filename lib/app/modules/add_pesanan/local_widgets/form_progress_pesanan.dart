import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/data/services/aktivitas_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/auth_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/user_service.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/controllers/add_pesanan_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/local_widgets/dialog_add_progress_pesanan.dart';

import 'package:get/get.dart';

class FormProgressPesanan extends StatefulWidget {
  final String? id;

  const FormProgressPesanan({Key? key, this.id}) : super(key: key);

  @override
  State<FormProgressPesanan> createState() => _FormProgressPesananState();
}

class _FormProgressPesananState extends State<FormProgressPesanan> {
  List<Widget> children = [];
  List<Widget> child = [];
  final controller = Get.find<AddPesananController>();

  @override
  void initState() {
    super.initState();
    children.add(
      Visibility(
        visible: isAdmin(), //&& (controller.progressPesanan.length < 4),
        child: ElevatedButton(
          onPressed: addProgress,
          child: const Text("TAMBAH"),
        ),
      ),
    );
    refresh();
  }

  void addProgress() async {
    Map<String, dynamic>? hasil = await showDialog(
      context: context,
      builder: (ctx) => DialogAddProgressPesanan(),
      barrierDismissible: false,
    );
    if (hasil != null) {
      log(controller.progressPesanan.toString());
      hasil["pekerja"] = hasil["pekerja"]["id"];
      hasil["aktivitas"] = hasil["aktivitas"]["id"];
      int index = controller.progressPesanan
          .indexWhere((element) => element["aktivitas"] == hasil["aktivitas"]);
      if (index == -1) {
        controller.progressPesanan.add(hasil);
      } else {
        controller.progressPesanan.removeAt(index);
        controller.progressPesanan.insert(index, hasil);
      }
    }
    refresh();
  }

  void editProgress(int index) async {
    Map<String, dynamic>? hasil = await showDialog(
        context: context,
        builder: (ctx) => DialogAddProgressPesanan(id: index));
    if (hasil != null) {
      hasil["pekerja"] = hasil["pekerja"]["id"];

      hasil["aktivitas"] = hasil["aktivitas"]["id"];
      controller.progressPesanan[index] = hasil;
    }
    refresh();
  }

  Future<List<Widget>> getList() async {
    List<Widget> child = [];
    for (var e in controller.progressPesanan) {
      log(e.toString());
      var userService = UserService();
      var temp = <String, dynamic>{};
      temp.addAll(e);
      log(temp.toString());
      Map<String, dynamic>? user = await userService.getData(temp["pekerja"]);
      temp["pekerja"] = user;

      var aktivitasService = AktivitasService();
      //var tempAkt = <String, dynamic>{};
      //tempAkt.addAll(e);
      //log(tempAkt.toString());
      Map<String, dynamic>? aktivitas =
          await aktivitasService.getData(temp["aktivitas"]);
      temp["aktivitas"] = {
        "id": aktivitas!["id"],
        "nama": aktivitas["aktivitas"]
      };

      child.add(tahapCard(temp));
    }
    return child;
  }

  void refresh() async {
    await getList().then((value) => child = value).whenComplete(() {
      setState(() {
        // if (controller.progressPesanan.length == 4) {
        //   children[0] = Visibility(
        //     visible: isAdmin() && (controller.progressPesanan.length < 4),
        //     child: ElevatedButton(
        //       onPressed: addProgress,
        //       child: const Text("TAMBAH"),
        //     ),
        //   );
        // }
        children.replaceRange(1, children.length, child);
      });
    });
  }

  Widget tahapCard(Map<String, dynamic> hasil) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text("${hasil["persentase"]}%",
              style: const TextStyle(fontSize: 14)),
        ),
        title: Text("${hasil["aktivitas"]["nama"]}"),
        subtitle:
            Text("(${LABEL[hasil["tahap"]]})\n${hasil["pekerja"]["nama"]}"),
        trailing:
            (hasil["pekerja"]["id"] == AuthService.userData["id"]) || isAdmin()
                ? IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                    onPressed: () async {
                      int index = controller.progressPesanan.indexWhere(
                          (element) => element["tahap"] == hasil["tahap"]);
                      editProgress(index);
                    })
                : null,
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
