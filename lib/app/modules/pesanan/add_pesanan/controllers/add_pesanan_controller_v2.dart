// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/data/services/aktivitas_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/bahan_baku_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/fcm_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/pesanan_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/user_service.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/local_widgets/dialog_add_bahan_baku.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/local_widgets/dialog_add_dokumentasi.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/local_widgets/dialog_add_progress_pesanan.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/local_widgets/dialog_existing_pemesan.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/views/add_pesanan_view.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';

class AddPesananControllerV2 extends BaseController<AddPesananPage> {
  @override
  Widget build(BuildContext context) => AddPesananView(state: this);

  final PesananService service = PesananService();
  final FCMService fcmService = FCMService();

  final detail = ValueNotifier<Map<String, dynamic>?>({});
  final isLoading = ValueNotifier<bool>(false);
  String? get id => widget.id;

  final currentStep = ValueNotifier<int>(0);

  static final formKey = [
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>()
  ];

  // INFORMASI PEMESAN

  // PEMESAN
  final listUser = ValueNotifier<List<Map<String, dynamic>>?>([]);

  // BAHAN BAKU
  final listBahanBaku = ValueNotifier<List<Map<String, dynamic>>?>([]);

  // PROGRESS PESANAN
  final listPekerja = ValueNotifier<List<Map<String, dynamic>>?>([]);
  final listAktivitas = ValueNotifier<List<Map<String, dynamic>>?>([]);

  // DOKUMENTASI

  List<String> pekerja = [];
  Map<String, dynamic> oldBahanBaku = {};
  Map<String, dynamic> bahanBaku = {};
  Map<String, dynamic> pemesan = {};
  List<Map<String, dynamic>> progressPesanan = [];
  Map<String, dynamic> informasiPesanan = {};

  Map<String, dynamic> tempListBahanBaku = {};

  List<String> fotoUrl = [];
  bool newPembeli = true;

  void onCheckStepContinue(int stepLength) async {
    if (currentStep.value == stepLength - 1) {
      Future<bool> hasil = id == null
          ? showConfirmationAddDialog(context)
          : showConfirmationEditDialog(context);
      hasil.then((value) {
        if (value) {
          simpan(id);
        }
      });
    } else {
      onStepContinue();
    }
  }

  void onStopCancel() {
    currentStep.value == 0 ? null : currentStep.value--;
    // update();
  }

  void onStepTapped(index) {
    if (id == null) {
      return;
    }
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
    currentStep.value = index;
    // update();
  }

  void onStepContinue() async {
    if (currentStep.value == 0 || currentStep.value == 1) {
      if (formKey[currentStep.value].currentState!.validate()) {
        formKey[currentStep.value].currentState!.save();
        if (currentStep.value == 0) {
          informasiPesanan
              .addAll(formKey[currentStep.value].currentState!.value);
          currentStep.value++;
        } else if (currentStep.value == 1) {
          pemesan.addAll(formKey[currentStep.value].currentState!.value);
          if (newPembeli) {
            final UserService userService = UserService();
            String userid =
                await userService.findDuplicate("nohp", pemesan["nohp"]);
            if (userid == "") {
              log("ID:$userid");
              pemesan["id"] =
                  await userService.addNewPembeli(pemesan).then((value) {
                newPembeli = false;
              });
              currentStep.value++;
            } else {
              showInfoDialog(
                  "Gagal", "No HP User telah terdaftar silakan cek lagi");
            }
          } else {
            currentStep.value++;
          }
        }
      }
    } else if (currentStep.value == 3 && progressPesanan.isEmpty) {
      showInfoDialog("Gagal",
          "Progress Pesanan masih kosong. Silakan tambahkan progress pesanan.");
    } else {
      currentStep.value++;
    }
    // update();
  }

  // FORM PEMESAN
  void showDialogCariPemesan() {
    getListUser();
    openDialog(
      dialog: DialogExistingPemesan(state: this),
      barrierDismissible: false,
    ).then((hasil) {
      if (hasil != null) {
        pemesan["id"] = hasil["id"];
        AddPesananControllerV2.formKey[1].currentState!.fields["nama"]
            ?.didChange(hasil["nama"]);
        AddPesananControllerV2.formKey[1].currentState!.fields["nohp"]
            ?.didChange(hasil["nohp"]);
        AddPesananControllerV2.formKey[1].currentState!.fields["alamat"]
            ?.didChange(hasil["alamat"]);
        newPembeli = false;
      }
      log(hasil.toString() + newPembeli.toString());
    });
  }

  // FORM BAHAN BAKU
  void showDialogAddBahanBaku(Function callback) {
    getListBahanBaku();
    openDialog(
      dialog: DialogAddBahanBaku(state: this),
      barrierDismissible: false,
    ).then((hasil) {
      if (hasil != null) {
        bahanBaku[hasil["id"]] = hasil["jumlah"];
      }
      callback();
    });
  }

  void deleteBahanBaku(id, Function callback) {
    showConfirmationDeleteDialog(context).then((confirm) {
      if (confirm) {
        bahanBaku.removeWhere((key, value) => key == id);
        callback();
      }
    });
  }

  // FORM PROGRESS PESANAN

  void showDialogAddProgress({int? index, required Function callback}) async {
    getListAktivitas();
    getListPekerja();
    openDialog(
      dialog: DialogAddProgressPesanan(
        id: index,
        state: this,
      ),
      barrierDismissible: false,
    ).then((hasil) {
      if (hasil != null) {
        handleProgressPesanan(index, hasil);
      }
      callback();
    });
  }

  void handleProgressPesanan(int? index, hasil) async {
    if (index == null) {
      log(progressPesanan.toString());
      hasil["pekerja"] = hasil["pekerja"]["id"];
      hasil["aktivitas"] = hasil["aktivitas"]["id"];
      int index = progressPesanan
          .indexWhere((element) => element["aktivitas"] == hasil["aktivitas"]);
      if (index == -1) {
        progressPesanan.add(hasil);
      } else {
        progressPesanan.removeAt(index);
        progressPesanan.insert(index, hasil);
      }
    } else {
      hasil["pekerja"] = hasil["pekerja"]["id"];
      hasil["aktivitas"] = hasil["aktivitas"]["id"];
      progressPesanan[index] = hasil;
    }
  }

  // FORM DOKUMENTASI
  void showDialogAddDokumentasi(Function callback) {
    openDialog(
      dialog: const DialogAddDokumentasi(),
      barrierDismissible: false,
    ).then((hasil) async {
      if (hasil != null) {
        final ImagePicker picker = ImagePicker();
        XFile? image;
        if (hasil == "gallery") {
          image = await picker.pickImage(source: ImageSource.gallery);
        } else if (hasil == "camera") {
          image = await picker.pickImage(source: ImageSource.camera);
        }

        if (image != null) {
          var fileName =
              DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '');
          Reference ref = FirebaseStorage.instance.ref().child(fileName);
          UploadTask uploadTask = ref.putFile(File(image.path));
          TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
          final downloadUrl = await snapshot.ref.getDownloadURL();
          log(downloadUrl);
          fotoUrl.add(downloadUrl);
        }
      }
      callback();
    });
  }

  void deleteDokumentasi(url, Function callback) {
    showConfirmationDeleteDialog(context).then((confirm) {
      if (confirm) {
        fotoUrl.removeWhere((element) => element == url);
        callback();
      }
    });
  }

  void simpan(String? id) {
    showOverlay.value = true;
    // update();
    Map<String, dynamic> perkiraanSelesaiTahap =
        getTanggalPerkiraanSelesaiTahap(
            progressPesanan, informasiPesanan["tanggalPesan"]);
    if (stringToDate(perkiraanSelesaiTahap["pemasangan"])
        .isAfter(stringToDate(informasiPesanan["perkiraanSelesai"]))) {
      informasiPesanan["perkiraanSelesai"] =
          perkiraanSelesaiTahap["pemasangan"];
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

    detail.value!["info"] = informasiPesanan;
    detail.value!["progress"] = progressPesanan;
    detail.value!["bahanBaku"] = bahanBaku;
    detail.value!["pemesan"] = pemesan;
    detail.value!["foto"] = fotoUrl;

    if (id == null) {
      tambahData(detail.value!);
    } else {
      editData(id, detail.value!);
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
      Navigator.pop(context);
      showInfoDialog("Berhasil", "Menambahkan Data");
    }).catchError((error, stackTrace) {
      Navigator.pop(context);
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

      Navigator.pop(context);
      showInfoDialog("Berhasil", "Mengubah Data");
    }).catchError((error, stackTrace) {
      Navigator.pop(context);
      showInfoDialog("Gagal", "Mengubah Data $error");
    });
  }

  void getData() async {
    log("add pesanan get data");
    isLoading.value = true;
    newPembeli = false;
    detail.value = {};
    // update();
    service.getData(id!).then((value) {
      detail.value = value;

      informasiPesanan = detail.value!["info"];
      pemesan = detail.value!["pemesan"];
      oldBahanBaku.addAll(detail.value!["bahanBaku"]);
      bahanBaku.addAll(detail.value!["bahanBaku"]);
      tempListBahanBaku.addAll(detail.value!["bahanBaku"]);
      for (var e in detail.value!["progress"]) {
        progressPesanan.add(e);
      }

      for (var foto in detail.value!["foto"]) {
        fotoUrl.add(foto);
      }
    }).catchError((error, stackTrace) {
      detail.value = {};
      showInfoDialog("Gagal", "Menampilkan Data $error");
    }).whenComplete(() {
      isLoading.value = false;
      if (!isAdmin()) {
        currentStep.value = 3;
        // update();
      }
      // update();
    });
  }

  void getListPekerja() async {
    final UserService userService = UserService();
    userService.listDataNotPembeli().then((value) {
      listPekerja.value = value;
    }).catchError((error, stackTrace) {
      listPekerja.value = [];
      showInfoDialog("Gagal", "Menampilkan Data $error");
    }).whenComplete(() {
      // update();
    });
  }

  void getListUser() async {
    log("add pesanan get list user");
    final UserService userService = UserService();
    userService.listData().then((value) {
      listUser.value = value;
    }).catchError((error, stackTrace) {
      listUser.value = [];
      showInfoDialog("Gagal", "Menampilkan Data $error");
    }).whenComplete(() {
      // update();
    });
  }

  void getListBahanBaku() async {
    log("add pesanan get list bahan baku");
    final BahanBakuService bahanBakuService = BahanBakuService();
    bahanBakuService.listDataNotEmpty(tempListBahanBaku).then((value) {
      listBahanBaku.value = value;
    }).catchError((error, stackTrace) {
      listBahanBaku.value = [];
      showInfoDialog("Gagal", "Menampilkan Data $error");
    }).whenComplete(() {
      // update();
    });
  }

  void getListAktivitas([String tahap = "all"]) async {
    log("add pesanan get list aktivitas");
    final AktivitasService aktivitasService = AktivitasService();
    aktivitasService.listData(tahap).then((value) {
      listAktivitas.value = value;
    }).catchError((error, stackTrace) {
      listAktivitas.value = [];
      showInfoDialog("Gagal", "Menampilkan Data $error");
    }).whenComplete(() {
      log(listAktivitas.value!.length.toString());
      // update();
    });
  }
}
