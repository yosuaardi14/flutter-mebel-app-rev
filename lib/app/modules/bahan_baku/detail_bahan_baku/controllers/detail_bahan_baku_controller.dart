import 'dart:developer';

import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/bahan_baku_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/pesanan_service.dart';
import 'package:get/get.dart';

class DetailBahanBakuController extends GetxController {
  final BahanBakuService service = BahanBakuService();
  final PesananService pesananService = PesananService();
  final isLoading = false.obs;
  final isLoadPengunaan = false.obs;
  Map<String, dynamic>? detail = {};

  List<Map<String, dynamic>> historiPengunaan = [];
  List<Map<String, dynamic>> historiTambah = [];

  void addStok(Map<String, dynamic> data) async {
    Map<String, dynamic> newData = {};
    newData["stok"] = data["stok"] + data["jumlah"];
    newData["harga"] = data["harga"];
    newData["histori-tambah"] = data["histori-tambah"];
    newData["histori-tambah"].add({
      "tanggal": dateTimeToString(DateTime.now()),
      "jumlah": data["jumlah"],
      "harga": data["harga"]
    });
    await service.updateData(data["id"], newData);
  }

  void getData(String id) async {
    log("detail bahan baku get data");
    isLoading(true);
    detail = {};
    update();
    detail = await service.getData(id).catchError((error, stackTrace) {
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });

    int maxLength = 0;
    //get histori tambah
    historiTambah = [];
    for (var i in detail!["histori-tambah"]) {
      historiTambah.add(i);
    }
    historiTambah.sort((a, b) {
      var tanggal1 = initValDateTime("", a["tanggal"])!;
      var tanggal2 = initValDateTime("", b["tanggal"])!;
      return tanggal2.compareTo(tanggal1);
    });
    maxLength = historiTambah.length > 5 ? 5 : historiTambah.length;
    historiTambah = historiTambah.sublist(0, maxLength);

    historiPengunaan = [];
    List<Map<String, dynamic>>? allPesanan = await pesananService.listData();
    for (var e in detail!["histori-kurang"].entries) {
      if (e.value != 0) {
        Map<String, dynamic>? pesanan = allPesanan!.firstWhereOrNull((element) {
          return element["id"] == e.key;
        });
        if (pesanan != null) {
          historiPengunaan.add({
            "tanggal": pesanan["info"]["tanggalPesan"],
            "nama": pesanan["info"]["nama"],
            "jumlah": e.value
          });
        }
      }
    }
    historiPengunaan.sort((a, b) {
      var tanggal1 = initValDate("", a["tanggal"])!;
      var tanggal2 = initValDate("", b["tanggal"])!;
      return tanggal2.compareTo(tanggal1);
    });
    maxLength = historiPengunaan.length > 5 ? 5 : historiPengunaan.length;
    historiPengunaan = historiPengunaan.sublist(0, maxLength);
    isLoading(false);
    update();
  }

  void deleteData(String id) async {
    if (historiPengunaan.isEmpty) {
      await service.deleteData(id).then((value) {
        Get.back();
        showInfoDialog("Berhasil", "Menghapus Data");
      }).onError((error, stackTrace) {
        Get.back();
        showInfoDialog("Gagal", "Menghapus Data $error");
      });
    } else {
      showInfoDialog(
          "Gagal", "Menghapus Data bahan baku masih digunakan pada Pesanan");
    }
  }
}
