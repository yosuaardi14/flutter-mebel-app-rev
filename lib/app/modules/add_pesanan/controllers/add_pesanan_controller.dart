import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/data/services/aktivitas_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/bahan_baku_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/fcm_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/pesanan_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/user_service.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class AddPesananController extends GetxController {
  static final formKey = [
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>()
  ];

  final PesananService service = PesananService();
  final FCMService fcmService = FCMService();

  Map<String, dynamic>? detail = {};
  final isLoading = false.obs;

  int currentStep = 0;
  List<String> pekerja = [];
  Map<String, dynamic> oldBahanBaku = {};
  Map<String, dynamic> bahanBaku = {};
  Map<String, dynamic> pemesan = {};
  List<Map<String, dynamic>> progressPesanan = [];
  Map<String, dynamic> informasiPesanan = {};

  List<Map<String, dynamic>>? listPekerja = [];
  List<Map<String, dynamic>>? listBahanBaku = [];
  List<Map<String, dynamic>>? listAktivitas = [];
  Map<String, dynamic> tempListBahanBaku = {};

  List<Map<String, dynamic>>? listUser = [];

  List<String> fotoUrl = [];
  bool newPembeli = true;

  bool isSaving = false;

  void onStopCancel() {
    currentStep == 0 ? null : currentStep--;
    update();
  }

  void onStepTapped(index) {
    if (formKey[0].currentState!.validate()) {
      formKey[0].currentState!.save();
      informasiPesanan.addAll(formKey[0].currentState!.value);
    } else {
      index = 0;
    }
    if (formKey[1].currentState!.validate()) {
      formKey[1].currentState!.save();
      pemesan.addAll(formKey[1].currentState!.value);
    } else {
      index = 1;
    }
    currentStep = index;
    update();
  }

  void onStepContinue() async {
    if (currentStep == 0 || currentStep == 1) {
      if (formKey[currentStep].currentState!.validate()) {
        formKey[currentStep].currentState!.save();
        if (currentStep == 0) {
          informasiPesanan.addAll(formKey[currentStep].currentState!.value);
          currentStep++;
        } else if (currentStep == 1) {
          pemesan.addAll(formKey[currentStep].currentState!.value);
          if (newPembeli) {
            final UserService userService = UserService();
            String userid =
                await userService.findDuplicate("nohp", pemesan["nohp"]);
            if (userid == "") {
              log("ID:" + userid.toString());
              pemesan["id"] =
                  await userService.addNewPembeli(pemesan).then((value) {
                newPembeli = false;
              });
              currentStep++;
            } else {
              showInfoDialog(
                  "Gagal", "No HP User telah terdaftar silakan cek lagi");
            }
          } else {
            currentStep++;
          }
        }
      }
    } else if (currentStep == 3 && progressPesanan.isEmpty) {
      showInfoDialog("Gagal",
          "Progress Pesanan masih kosong. Silakan tambahkan progress pesanan.");
    } else {
      currentStep++;
    }
    update();
  }

  void simpan(String? id) {
    isSaving = true;
    update();
    Map<String, dynamic> perkiraanSelesaiTahap = getTanggalPerkiraanSelesaiTahap(progressPesanan, informasiPesanan["tanggalPesan"]);
    if(stringToDate(perkiraanSelesaiTahap["pemasangan"]).isAfter(stringToDate(informasiPesanan["perkiraanSelesai"]))){
      informasiPesanan["perkiraanSelesai"] = perkiraanSelesaiTahap["pemasangan"];
    }
    if (getPresentaseProgress(progressPesanan) == 1 &&
        informasiPesanan["tanggalSelesai"] == "") {
      if (progressPesanan.length == 4) {
        informasiPesanan["tanggalSelesai"] = dateToString(DateTime.now());
      } else if (progressPesanan.length == 2) {
        if (progressPesanan[1]["tahap"] == "perakitan" &&
            progressPesanan[1]["persentase"] == 100) {
          informasiPesanan["tanggalSelesai"] = dateToString(DateTime.now());
        }
      }
    }

    detail!["info"] = informasiPesanan;
    detail!["progress"] = progressPesanan;
    detail!["bahanBaku"] = bahanBaku;
    detail!["pemesan"] = pemesan;
    detail!["foto"] = fotoUrl;

    if (id == null) {
      tambahData(detail!);
    } else {
      editData(id, detail!);
    }
  }

  void tambahData(Map<String, dynamic> data) async {
    int notificationid = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    data["notifid"] = notificationid;
    await service.addData(data).then((value) async {
      final BahanBakuService bahanBakuService = BahanBakuService();
      for (var item in data["bahanBaku"].entries) {
        log("Jumlah: ${item.value}, Old: 0");
        await bahanBakuService.updateStok(item.key, item.value, 0);

        //add to histori
        await bahanBakuService.updateData(item.key, {
          "histori-kurang": {value: item.value}
        });
      }

      //add topic to user
      final UserService userService = UserService();
      await userService.addTopic(data["pemesan"]["id"], value!);

      //notifikasi
      var tahapIndex = 0;
      for (var i = 0; i < data["progress"].length; i++) {
        await userService.addTopic(data["progress"][i]["pekerja"], value);
        if (data["progress"][i]["persentase"] == 100 &&
            tahapIndex < (data["progress"].length - 1)) {
          tahapIndex++;
        }
      }

      String notificationTitle =
          "${data["info"]["nama"]} - Deadline Pesanan: ${data["info"]["perkiraanSelesai"]}";
      String notificationBody =
          "Pemesan: ${data["pemesan"]["nama"]}\nDeadline ${LABEL[data["progress"][tahapIndex]["tahap"]]} (${data["progress"][tahapIndex]["persentase"]}%) : ${data["progress"][tahapIndex]["perkiraanSelesai"]}";
      bool daily = false;
      bool scheduled = false;
      if (getPresentaseProgress(data["progress"]) == 1) {
        tahapIndex = data["progress"].length;
        //telah selesai
        notificationTitle = "${data["info"]["nama"]} - Pesanan telah selesai";
        notificationBody = "Pemesan: ${data["pemesan"]["nama"]}";
      } else {
        //belum selesai
        daily = true;
        scheduled = true;
      }
      await fcmService.sendTopicDailyNotification(
        value,
        notificationTitle,
        notificationBody,
        notificationid,
        scheduled: scheduled,
        daily: daily,
        time: DateTime.now().add(const Duration(seconds: 5)).toString(),
      );
      Get.back();
      showInfoDialog("Berhasil", "Menambahkan Data");
    }).catchError((error, stackTrace) {
      Get.back();
      showInfoDialog("Gagal", "Menambahkan Data $error");
    });
  }

  void editData(String id, Map<String, dynamic> data) async {
    await service.updateData(id, data).then((value) async {
      final BahanBakuService bahanBakuService = BahanBakuService();
      Map<String, dynamic> allBahanBaku = {};
      allBahanBaku.addAll(data["bahanBaku"]);
      allBahanBaku.addAll(oldBahanBaku);
      for (var item in allBahanBaku.entries) {
        var isNew = data["bahanBaku"].containsKey(item.key);
        var isOld = oldBahanBaku.containsKey(item.key);
        if (isOld && isNew) {
          //update
          await bahanBakuService.updateStok(
              item.key, data["bahanBaku"][item.key], oldBahanBaku[item.key]);
        } else if (isOld) {
          //delete
          await bahanBakuService.updateStok(
              item.key, 0, oldBahanBaku[item.key]);
        } else if (isNew) {
          //add
          await bahanBakuService.updateStok(
              item.key, data["bahanBaku"][item.key], 0);
        }
        await bahanBakuService.updateData(item.key, {
          "histori-kurang": {id: data["bahanBaku"][item.key] ?? 0}
        });
      }

      //add topic to user
      final UserService userService = UserService();
      await userService.addTopic(data["pemesan"]["id"], id);

      //notifikasi
      var tahapIndex = 0;
      for (var i = 0; i < data["progress"].length; i++) {
        await userService.addTopic(data["progress"][i]["pekerja"], id);
        if (data["progress"][i]["persentase"] == 100 &&
            tahapIndex < (data["progress"].length - 1)) {
          tahapIndex++;
        }
      }

      int notificationid = data["notifid"];

      String notificationTitle =
          "${data["info"]["nama"]} - Deadline Pesanan: ${data["info"]["perkiraanSelesai"]}";
      String notificationBody =
          "Pemesan: ${data["pemesan"]["nama"]}\nDeadline ${LABEL[data["progress"][tahapIndex]["tahap"]]} (${data["progress"][tahapIndex]["persentase"]}%) : ${data["progress"][tahapIndex]["perkiraanSelesai"]}";
      bool daily = false;
      bool scheduled = false;
      if (getPresentaseProgress(data["progress"]) == 1) {
        tahapIndex = data["progress"].length;
        notificationTitle = "${data["info"]["nama"]} - Pesanan telah selesai";
        notificationBody = "Pemesan: ${data["pemesan"]["nama"]}";
      } else {
        //set notification
        scheduled = true;
        daily = true;
      }
      await fcmService.sendTopicDailyNotification(
        id,
        notificationTitle,
        notificationBody,
        notificationid,
        scheduled: scheduled,
        daily: daily,
        time: DateTime.now().add(const Duration(minutes: 2)).toString(),
      );

      Get.back();
      showInfoDialog("Berhasil", "Mengubah Data");
    }).catchError((error, stackTrace) {
      Get.back();
      showInfoDialog("Gagal", "Mengubah Data $error");
    });
  }

  void getData(String id) async {
    log("add pesanan get data");
    isLoading(true);
    newPembeli = false;
    detail = {};
    update();
    await service.getData(id).then((value) {
      detail = value;

      informasiPesanan = detail!["info"];
      pemesan = detail!["pemesan"];
      oldBahanBaku.addAll(detail!["bahanBaku"]);
      bahanBaku.addAll(detail!["bahanBaku"]);
      tempListBahanBaku.addAll(detail!["bahanBaku"]);
      for (var e in detail!["progress"]) {
        progressPesanan.add(e);
      }

      for (var foto in detail!["foto"]) {
        fotoUrl.add(foto);
      }
    }).whenComplete(() {
      isLoading(false);
      update();
    }).catchError((error, stackTrace) {
      detail = {};
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });
    if (!isAdmin()) {
      currentStep = 3;
      update();
    }
  }

  void getListPekerja() async {
    final UserService userService = UserService();
    listPekerja = await userService.listDataNotPembeli().whenComplete(() {
      update();
    }).catchError((error, stackTrace) {
      listPekerja = [];
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });
  }

  void getListUser() async {
    log("add pesanan get list user");
    final UserService userService = UserService();
    listUser = await userService.listData().whenComplete(() {
      update();
    }).catchError((error, stackTrace) {
      listUser = [];
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });
  }

  void getListBahanBaku() async {
    log("add pesanan get list bahan baku");
    final BahanBakuService bahanBakuService = BahanBakuService();
    listBahanBaku = await bahanBakuService
        .listDataNotEmpty(tempListBahanBaku)
        .whenComplete(() {
      update();
    }).catchError((error, stackTrace) {
      listBahanBaku = [];
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });
  }

  void getListAktivitas([String tahap = "all"]) async {
    log("add pesanan get list aktivitas");
    final AktivitasService aktivitasService = AktivitasService();
    listAktivitas = await aktivitasService.listData(tahap).whenComplete(() {
      log(listAktivitas!.length.toString());
      update();
    }).catchError((error, stackTrace) {
      listAktivitas = [];
      showInfoDialog("Gagal", "Menampilkan Data $error");
    });
  }
}
