import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mebel_app_rev/app/data/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void copyToClipboard({String? value, String? label}) {
  Clipboard.setData(
    ClipboardData(text: value ?? ""),
  ).whenComplete(
    () => showSnackBar("", "${label ?? ""} telah dicopy"),
  );
}

bool isAdmin() {
  return AuthService.userData["role"] == "Admin";
}

bool isPembeli() {
  return AuthService.userData["role"] == "Pembeli";
}

String convertToIdr(dynamic number) {
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return currencyFormatter.format(number);
}

Future<void> showInfoDialog(String title, String content) async {
  return await showDialog(
    barrierDismissible: false,
    context: Get.context!,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Ok")),
      ],
    ),
  );
}

void showSnackBar(String title, String messages) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Text("$title $messages"),
      duration: const Duration(seconds: 2),
    ),
  );
}

Future<bool> showConfirmationDialog(
    BuildContext context, String title, String content) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Tidak")),
        const SizedBox(width: 20),
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Ya")),
      ],
    ),
  );
}

Future<bool> showConfirmationDeleteDialog(BuildContext context) async {
  return await showConfirmationDialog(
      context, "Konfirmasi Hapus", "Apa Anda yakin ingin menghapus ini?");
}

Future<bool> showConfirmationAddDialog(BuildContext context) async {
  return await showConfirmationDialog(
      context, "Konfirmasi Tambah", "Apa Anda yakin ingin menambah ini?");
}

Future<bool> showConfirmationEditDialog(BuildContext context) async {
  return await showConfirmationDialog(
      context, "Konfirmasi Ubah", "Apa Anda yakin ingin mengubah ini?");
}

Future<bool> showConfirmationSaveDialog(BuildContext context) async {
  return await showConfirmationDialog(context, "Konfirmasi Simpan",
      "Apa Anda yakin ingin menyimpan perubahan ini?");
}

//validasi
String? initValNoHp(String? id, String? data) {
  if (data != null && data.startsWith("+62")) {
    data = data.substring(3);
  }
  return id != null ? data : null;
}

DateTime? initValDate(String? id, String? data) {
  DateTime? val;
  if (data != null && data != "") {
    var temp = data.split("-");
    val = DateTime.parse("${temp[2]}-${temp[1]}-${temp[0]}");
  }
  return id != null ? val : null;
}

DateTime? initValDateProgress(
    int? index, List<Map<String, dynamic>>? data, String fieldname) {
  DateTime? val;
  dynamic value;
  if (data != null && index != null) {
    value = data[index][fieldname];
  }
  if (value != null && value != "") {
    var temp = value.split("-");
    val = DateTime.parse("${temp[2]}-${temp[1]}-${temp[0]}");
  }
  return index != null ? val : null;
}

String? initValProgress(
    int? index, List<Map<String, dynamic>>? data, String fieldname) {
  dynamic val, temp;
  if (data != null && index != null) {
    temp = data[index][fieldname];
  }
  if (temp != String && temp != null) {
    val = temp.toString();
  }
  if (fieldname == "persentase" && index == null) {
    return "0";
  }
  //baru
  if (fieldname == "waktu") {
    return "menit";
  }
  if (fieldname == "satuanP") {
    return "cm";
  }

  return index != null ? val : null;
}

// String? initValProgressSatuan(
//     int? index, List<Map<String, dynamic>>? data, String fieldname) {
//   dynamic val, temp;
//   if (data != null && index != null) {
//     temp = data[index][fieldname];
//   }
//   if (temp != String && temp != null) {
//     val = temp.toString();
//   }
//   if (fieldname == "persentase" && index == null) {
//     return "0";
//   }
//   //baru
//   if (fieldname == "waktu" && index == null) {
//     return "menit";
//   }
//   if (fieldname == "satuanP" && index == null) {
//     return "cm";
//   }
//   return index != null ? val : null;
// }

String? initValProgressTahap(int? index, List<Map<String, dynamic>>? data) {
  List<String> tahap = ["pengukuran", "pemotongan", "perakitan", "pemasangan"];
  // if (index == null && data != null) {
  //   return tahap[data.length];
  // } else
  if (data != null && index != null) {
    return data[index]["tahap"];
  } else {
    return null;
  }
}

String? initValBahanBaku(
    String? id, List<Map<String, dynamic>>? data, String fieldname) {
  dynamic val, temp;
  if (data != null && id != null) {
    temp = data.firstWhere((element) => element["id"] == id)["nama"];
    log("value:" + temp);
  }
  if (temp != String && temp != null) {
    val = temp.toString();
  }
  return id != null ? val : null;
}

String? initValCheck(String? id, dynamic data) {
  if (data != String) {
    data = data.toString();
  }
  return id != null ? data : null;
}

int valToInt(String? data) {
  int val = 0;
  if (data != null && isInt(data)) {
    val = int.parse(data);
  }
  return val;
}

bool isInt(String str) {
  try {
    int.parse(str);
    return true;
  } catch (e) {
    return false;
  }
}

bool isDate(String str) {
  try {
    DateTime.parse(str);
    return true;
  } catch (e) {
    return false;
  }
}

DateTime? initValDateTime(String? id, String? data) {
  DateTime? val;
  if (data != null && data != "") {
    var temp = data.split(" ");
    var tempDate = temp[0].split("-");
    var tempTime = temp[1].split(":");
    val = DateTime.parse(
        "${tempDate[2]}-${tempDate[1]}-${tempDate[0]} ${tempTime[0]}:${tempTime[1]}:${tempTime[2]}");
  }
  return id != null ? val : null;
}

String dateTimeToString(DateTime data) {
  return DateFormat("dd-MM-yyyy HH:mm:ss").format(data);
}

String dateToString(DateTime data) {
  return DateFormat("dd-MM-yyyy").format(data);
}

bool searchItems(String word, String searchWord) {
  return word.toLowerCase() == searchWord.toLowerCase() ||
      word.toLowerCase().startsWith(searchWord.toLowerCase()) ||
      word.toLowerCase().contains(searchWord.toLowerCase());
}

//baru
int currencyToInt(String? data) {
  int val = 0;
  if (data != null) {
    data = data.replaceAll(".", "");
    if (isInt(data)) {
      val = int.parse(data);
    }
    return val;
  }
  return val;
}

String? initCurrencyCheck(String? id, dynamic data) {
  if (data != String) {
    data = data.toString();
    double value = double.tryParse(data) ?? 0;

    final formatter = NumberFormat.currency(
      locale: "id",
      symbol: "Rp",
      decimalDigits: 0,
    );

    data = formatter.format(value);
    data = data.replaceAll("Rp", "");
  }
  return id != null ? data : null;
}

double getPresentaseProgress(List<dynamic> progress) {
  int total = 0;
  int length = 4;
  int totalAll = (length * 100);
  for (var i in progress) {
    total += int.parse(i["persentase"].toString());
  }
  return total / totalAll;
}

//baru
double getPresentaseProgressNew(List<dynamic> progress) {
  int pengukuran = 0;
  int pemotongan = 0;
  int perakitan = 0;
  int pemasangan = 0;
  int total = 0;
  for (var i in progress) {
    if (i["tahap"] == "pengukuran") {
      pengukuran++;
    } else if (i["tahap"] == "pemotongan") {
      pemotongan++;
    } else if (i["tahap"] == "perakitan") {
      perakitan++;
    } else if (i["tahap"] == "pemasangan") {
      pemasangan++;
    }
    total += int.parse(i["persentase"].toString());
  }
  pengukuran = pengukuran == 0 ? 1 : pengukuran;
  pemotongan = pemotongan == 0 ? 1 : pemotongan;
  perakitan = perakitan == 0 ? 1 : perakitan;
  pemasangan = pemasangan == 0 ? 1 : pemasangan;
  int totalAll = (pengukuran + pemotongan + perakitan + pemasangan) * 100;
  return total / totalAll;
}

double getPresentaseProgressTahap(List<dynamic> progress, String tahap) {
  int total = 0;
  int length = 0;
  for (var i in progress) {
    if (i["tahap"] == tahap) {
      total += int.parse(i["persentase"].toString());
      length++;
    }
  }
  length = length == 0 ? 1 : length;
  int totalAll = (length * 100);
  return total / totalAll;
}

Map<String, dynamic> getTanggalPerkiraanSelesaiTahap(
    List<dynamic> progress, String tanggalPesan) {
  int totalMenitPengukuran = 0;
  int totalMenitPemotongan = 0;
  int totalMenitPerakitan = 0;
  int totalMenitPemasangan = 0;

  for (var i in progress) {
    if (i["tahap"] == "pengukuran") {
      totalMenitPengukuran += int.parse(i["waktupengerjaan"].toString());
    } else if (i["tahap"] == "pemotongan") {
      totalMenitPemotongan += int.parse(i["waktupengerjaan"].toString());
    } else if (i["tahap"] == "perakitan") {
      totalMenitPerakitan += int.parse(i["waktupengerjaan"].toString());
    } else if (i["tahap"] == "pemasangan") {
      totalMenitPemasangan += int.parse(i["waktupengerjaan"].toString());
    }
  }

  DateTime tanggalPesanObj = stringToDate(tanggalPesan);
  Map<String, dynamic> hasil = {};
  hasil["pengukuran"] = dateToString(
      tanggalPesanObj.add(Duration(days: menitToHari(totalMenitPengukuran))));
  hasil["pemotongan"] = dateToString(stringToDate(hasil["pengukuran"])
      .add(Duration(days: menitToHari(totalMenitPemotongan))));
  hasil["perakitan"] = dateToString(stringToDate(hasil["pemotongan"])
      .add(Duration(days: menitToHari(totalMenitPerakitan))));
  hasil["pemasangan"] = dateToString(stringToDate(hasil["perakitan"])
      .add(Duration(days: menitToHari(totalMenitPemasangan))));
  return hasil;
}

String getTanggalPerkiraanSelesaiAktivitas(
    List<dynamic> progress, String tanggalPesan, String aktivitas) {
  int totalMenit = 0;
  for (var i in progress) {
    totalMenit += int.parse(i["waktupengerjaan"].toString());
    if (i["aktivitas"] == aktivitas) {
      break;
    }
  }

  DateTime tanggalPesanObj = stringToDate(tanggalPesan);
  DateTime hasil = tanggalPesanObj.add(Duration(days: menitToHari(totalMenit)));

  return dateToString(hasil);
}

DateTime stringToDate(String tanggal) {
  var temp = tanggal.split("-");
  return DateTime.parse("${temp[2]}-${temp[1]}-${temp[0]}");
}

int menitToHari(int val) {
  return (val / 420).round();
}

int menitToJam(int val) {
  return (val / 60).round();
}

int jamToHari(int val) {
  return (val / 7).round();
}

DateTime? initValDateProgressPerkiraanSelesai(
    int? index, List<Map<String, dynamic>>? data, String tanggalPesan) {
  DateTime? val;
  dynamic value;
  if (data != null && index != null) {
    value = getTanggalPerkiraanSelesaiAktivitas(
        data, tanggalPesan, data[index]["aktivitas"]);
  }
  if (value != null && value != "") {
    var temp = value.split("-");
    val = DateTime.parse("${temp[2]}-${temp[1]}-${temp[0]}");
  }
  return index != null ? val : null;
}
