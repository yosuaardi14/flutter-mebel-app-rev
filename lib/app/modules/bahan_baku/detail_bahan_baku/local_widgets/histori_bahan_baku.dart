import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';

class HistoriBahanBaku extends StatelessWidget {
  bool plus;
  List<dynamic> data;
  HistoriBahanBaku({Key? key, required this.data, required this.plus})
      : super(key: key);

  Widget jumlahText(String jumlah) {
    var textJumlah = plus ? "+ $jumlah" : "- $jumlah";
    var colorTipe = plus ? Colors.green : Colors.red;
    return Text(
      textJumlah,
      style: TextStyle(color: colorTipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Histori ${plus ? "Penambahan" : "Penggunaan"}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            data.isEmpty
                ? const Text("Belum ada histori")
                : Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      const TableRow(children: [
                        TableCell(
                            child: Text("Tanggal",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        TableCell(
                            child: Text("Deskripsi",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        TableCell(
                            child: Text("Jumlah",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ]),
                      ...data.map((e) {
                        return TableRow(children: [
                          TableCell(
                              child: Text(plus
                                  ? dateToString(
                                      initValDateTime("", e["tanggal"])!)
                                  : e["tanggal"])),
                          TableCell(
                            child: Text(
                              plus
                                  ? "Pembelian dengan harga @${convertToIdr(e["harga"])}"
                                  : "Digunakan pada pesanan ${e["nama"]}",
                            ),
                          ),
                          TableCell(
                            child: jumlahText(e["jumlah"].toString()),
                          ),
                        ]);
                      }),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
