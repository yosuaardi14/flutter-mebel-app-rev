import 'package:flutter/material.dart';

class DialogAddDokumentasi extends StatelessWidget {
  const DialogAddDokumentasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tambah Foto"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text("Kembali")),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, "camera");
            },
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                SizedBox(width: 10),
                Text("Ambil Foto"),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, "gallery");
            },
            child: Row(
              children: const [
                Icon(Icons.image),
                SizedBox(width: 10),
                Text("Pilih dari Galeri"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
