// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/bahan_baku_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/pesanan_service.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/add_bahan_baku/views/add_bahan_baku_view.dart';
// import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/detail_bahan_baku/local_widgets/dialog_add_stok_bahan_baku.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/detail_bahan_baku/local_widgets/dialog_add_stok_bahan_baku_fullscreen.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/detail_bahan_baku/views/detail_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:get/get.dart';

class DetailBahanBakuController extends BaseController<DetailBahanBakuPage> {
  @override
  Widget build(BuildContext context) => DetailBahanBakuView(state: this);

  final BahanBakuService service = BahanBakuService();
  final PesananService pesananService = PesananService();
  final isLoading = ValueNotifier<bool>(false);
  final isLoadPengunaan = ValueNotifier<bool>(false);
  final detail = ValueNotifier<Map<String, dynamic>?>({});

  String? get id => widget.id;

  final historiPengunaan = ValueNotifier<List<Map<String, dynamic>>>([]);
  final historiTambah = ValueNotifier<List<Map<String, dynamic>>>([]);

  // List<Map<String, dynamic>> historiPengunaan = [];
  // List<Map<String, dynamic>> historiTambah = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void onEditBahanBaku(String id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBahanBakuPage(id: id),
      ),
    ).whenComplete(getData);
  }

  void tambahStokBahanBaku() async {
    // Full Screen Dialog
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DialogAddStokBahanBakuFullscreen(bahanBaku: detail.value!),
        fullscreenDialog: true,
      ),
    ).then(
      (value) {
        if (value != null) {
          addStok(value);
        }
      },
    ).whenComplete(getData);
    // openDialog(
    //   dialog: DialogAddStokBahanBaku(bahanBaku: detail.value!),
    //   barrierDismissible: false,
    // ).then((value) {
    //   if (value != null) {
    //     addStok(value);
    //   }
    // }).whenComplete(getData);
  }

  void onDeleteBahanBaku() async {
    showConfirmationDeleteDialog(context).then((value) {
      if (value) {
        deleteData(id!);
      }
    });
  }

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
    service.updateData(data["id"], newData).then((value) {
      showInfoDialog("Berhasil", "Menambah Stok");
    }).catchError((error, stackTree) {
      showInfoDialog("Gagal", "Menambah Stok $error");
    });
  }

  void getData() async {
    log("detail bahan baku get data");
    isLoading.value = true;
    detail.value = {};
    service.getData(id!).then((value) {
      detail.value = value;
      int maxLength = 0;
      //get histori tambah
      historiTambah.value = [];
      for (var i in detail.value!["histori-tambah"]) {
        historiTambah.value.add(i);
      }
      historiTambah.value.sort((a, b) {
        var tanggal1 = initValDateTime("", a["tanggal"])!;
        var tanggal2 = initValDateTime("", b["tanggal"])!;
        return tanggal2.compareTo(tanggal1);
      });
      maxLength =
          historiTambah.value.length > 5 ? 5 : historiTambah.value.length;
      historiTambah.value = historiTambah.value.sublist(0, maxLength);

      historiPengunaan.value = [];
      List<Map<String, dynamic>>? allPesanan;

      pesananService.listData().then((pesanan) {
        allPesanan = pesanan;
        for (var e in detail.value!["histori-kurang"].entries) {
          if (e.value != 0) {
            Map<String, dynamic>? pesanan =
                allPesanan!.firstWhereOrNull((element) {
              return element["id"] == e.key;
            });
            if (pesanan != null) {
              historiPengunaan.value.add({
                "tanggal": pesanan["info"]["tanggalPesan"],
                "nama": pesanan["info"]["nama"],
                "jumlah": e.value
              });
            }
          }
        }
        historiPengunaan.value.sort((a, b) {
          var tanggal1 = initValDate("", a["tanggal"])!;
          var tanggal2 = initValDate("", b["tanggal"])!;
          return tanggal2.compareTo(tanggal1);
        });
        maxLength = historiPengunaan.value.length > 5
            ? 5
            : historiPengunaan.value.length;
        historiPengunaan.value = historiPengunaan.value.sublist(0, maxLength);
        isLoading.value = false;
      }).catchError((error, stackTree) {
        showInfoDialog("Gagal", "Menampilkan Data $error");
      });
    }).catchError((error, stackTrace) {
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });
  }

  void deleteData(String id) async {
    if (historiPengunaan.value.isEmpty) {
      service.deleteData(id).then((value) {
        Navigator.pop(context);
        showInfoDialog("Berhasil", "Menghapus Data");
      }).catchError((error, stackTrace) {
        Navigator.pop(context);
        showInfoDialog("Gagal", "Menghapus Data $error");
      });
    } else {
      showInfoDialog(
          "Gagal", "Menghapus Data bahan baku masih digunakan pada Pesanan");
    }
  }
}
