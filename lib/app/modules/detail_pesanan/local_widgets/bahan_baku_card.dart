import 'package:flutter/material.dart';

class BahanBakuCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  const BahanBakuCard({Key? key, required this.title, required this.data})
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...data.entries
                    .map((e) => ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(e.value["nama"] + ": ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(e.value["jumlah"].toString()),
                          ),
                          horizontalTitleGap: 10.0,
                        ))
                    .toList()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
