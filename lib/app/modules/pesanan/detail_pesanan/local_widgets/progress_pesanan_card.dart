import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';

class ProgressPesananCard extends StatelessWidget {
  dynamic data;
  ProgressPesananCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LABEL[data["tahap"]],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              Text(
                "${data["persentase"].toString()}%",
                style: TextStyle(
                  fontSize: 18,
                  color: data["persentase"] == 100 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TahapCard(label: "Pekerja: ", value: data["pekerja"]?["nama"]),
          TahapCard(
              label: "Perkiraan Selesai: ", value: data["perkiraanSelesai"]),
          TahapCard(label: "Tanggal Selesai: ", value: data["tanggalSelesai"]),
          const Text(
            "Catatan:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("${data["catatan"] ?? ""}", maxLines: 5),
        ]),
      ),
    );
  }
}

class ProgressPesananCardNew extends StatelessWidget {
  dynamic data;
  ProgressPesananCardNew({Key? key, required this.data}) : super(key: key);

  Color getTextColor(int persentase) {
    if (persentase == 100) {
      return Colors.green;
    } else if (persentase >= 75) {
      return Colors.yellow.shade800;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    //Map<String, dynamic> tanggalTahap = getTanggalPerkiraanSelesaiTahap(data, tanggalPesan);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nama Aktivitas - ${LABEL[data["tahap"]]}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              Text(
                "${getPresentaseProgressTahap(data, data["tahap"]).toString()}%",
                style: TextStyle(
                  fontSize: 18,
                  color: data["persentase"] == 100 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TahapCard(label: "Pekerja: ", value: data["pekerja"]?["nama"]),
          TahapCard(
              label: "Perkiraan Selesai: ", value: data["perkiraanSelesai"]),
          TahapCard(label: "Tanggal Selesai: ", value: data["tanggalSelesai"]),
          const Text(
            "Catatan:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("${data["catatan"] ?? ""}", maxLines: 5),
        ]),
      ),
    );
  }
}

class TahapCard extends StatelessWidget {
  final String? label;
  final String? value;
  final MainAxisAlignment mainAxisAlignment;
  const TahapCard({
    Key? key,
    this.label,
    this.value,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 56.0),
      child: Column(
        children: [
          Row(mainAxisAlignment: mainAxisAlignment, children: [
            Text(
              label ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(value ?? "-",
                softWrap: true, overflow: TextOverflow.visible, maxLines: 4),
          ]),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
