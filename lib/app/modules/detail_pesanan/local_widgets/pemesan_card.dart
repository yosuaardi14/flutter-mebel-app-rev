import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_pesanan/local_widgets/info_card.dart';
import 'package:url_launcher/url_launcher.dart';

class PemesanCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  const PemesanCard({Key? key, required this.title, required this.data})
      : super(key: key);

  Future<void> launchWa() async {
    var nohp = data["nohp"];
    Uri url = Uri.parse('https://wa.me/$nohp/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  Flexible(
                    flex: 2,
                    child: Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Visibility(
                    visible: !isPembeli(),
                    replacement: const Spacer(),
                    child: Flexible(
                      child: TextButton(
                        onPressed: launchWa,
                        child: const Text("CHAT"),
                      ),
                    ),
                  )
                ],
              ),
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
