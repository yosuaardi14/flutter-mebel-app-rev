import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';

class CustomCardPesanan extends StatelessWidget {
  final Map<String, dynamic> pesanan;
  final void Function()? onTap;
  final void Function()? onEdit;
  const CustomCardPesanan(
      {Key? key, required this.pesanan, this.onTap, this.onEdit})
      : super(key: key);

  Color getTextColor(String tanggal) {
    var temp = tanggal.split("-");
    DateTime deadline = DateTime.parse("${temp[2]}-${temp[1]}-${temp[0]}");
    DateTime now = DateTime.now();
    int dateDiff = (deadline.difference(now).inHours / 24).round();
    if ((dateDiff < 3 && now.isBefore(deadline)) || now.isAfter(deadline)) {
      return Colors.red;
    } else {
      return Colors.yellow.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    var selesai = getPresentaseProgress(pesanan["progress"]) == 1 &&
        (pesanan["progress"].length == 2 || pesanan["progress"].length == 4);
    return Card(
      elevation: 3,
      child: ListTile(
          title: Text(
            pesanan["info"]?["nama"] ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pesan: ${pesanan["info"]?["tanggalPesan"].toString() ?? ""}"),
                  selesai
                      ? Text(
                          "Selesai: ${pesanan["info"]?["tanggalSelesai"].toString() ??
                                  ""}",
                          style: const TextStyle(color: Colors.green),
                        )
                      : Text(
                          "Deadline: ${pesanan["info"]?["perkiraanSelesai"]
                                      .toString() ??
                                  ""}",
                          style: TextStyle(
                              color: getTextColor((pesanan["info"]
                                      ?["perkiraanSelesai"])
                                  .toString())),
                        )
                ],
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                  value: getPresentaseProgress(pesanan["progress"]),
                  color: Colors.green),
            ],
          ),
          onTap: onTap),
    );
  }
}

class CustomCardUser extends StatelessWidget {
  final Map<String, dynamic> user;
  final void Function()? onTap;
  final void Function()? onEdit;
  const CustomCardUser({Key? key, required this.user, this.onTap, this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
          title: Text(
            user["nama"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LABEL[user["role"]] ?? user["role"]),
            ],
          ),
          onTap: onTap),
    );
  }
}

class CustomCardBahanBaku extends StatelessWidget {
  final Map<String, dynamic> bahanBaku;
  final void Function()? onTap;
  final void Function()? onEdit;
  const CustomCardBahanBaku(
      {Key? key, required this.bahanBaku, this.onTap, this.onEdit})
      : super(key: key);

  Color getTextColor(int stok) {
    if (stok == 0) {
      return Colors.red;
    } else if (stok > 0 && stok <= 5) {
      return Colors.yellow.shade800;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
          title: Text(
            bahanBaku["nama"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Stok: ${bahanBaku["stok"].toString()}",
            style: TextStyle(
              color: getTextColor(bahanBaku["stok"]),
            ),
          ),
          onTap: onTap),
    );
  }
}

class CustomCardAktivitas extends StatelessWidget {
  final Map<String, dynamic> aktivitas;
  final void Function()? onTap;
  final void Function()? onEdit;
  const CustomCardAktivitas(
      {Key? key, required this.aktivitas, this.onTap, this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
          title: Text(
            aktivitas["aktivitas"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "${LABEL[aktivitas["tahap"]]}",
          ),
          onTap: onTap),
    );
  }
}
