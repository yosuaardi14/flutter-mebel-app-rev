import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_pesanan/local_widgets/info_card.dart';

class PemesanCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  const PemesanCard({Key? key, required this.title, required this.data})
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
                InfoCard(label: "nohp", value: data["nohp"]),
                InfoCard(label: "alamat", value: data["alamat"]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
