import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/detail_pesanan/local_widgets/info_card.dart';

class InformasiPesananCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  const InformasiPesananCard(
      {Key? key, required this.title, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            title: Center(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                InfoCard(label: "nama", value: data["nama"]),
                InfoCard(
                    label: "harga", value: convertToIdr(data["harga"] ?? 0)),
                InfoCard(
                    label: "statusPembayaran", value: data["statusPembayaran"]),
                if (data["statusPembayaran"] == "dp")
                  InfoCard(
                      label: "dpharga",
                      value: convertToIdr(data["dpharga"] ?? 0)),
                InfoCard(label: "tanggalPesan", value: data["tanggalPesan"]),
                InfoCard(
                    label: "perkiraanSelesai", value: data["perkiraanSelesai"]),
                InfoCard(
                    label: "tanggalSelesai", value: data["tanggalSelesai"]),
                InfoCard(label: "deskripsi", value: data["deskripsi"]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
