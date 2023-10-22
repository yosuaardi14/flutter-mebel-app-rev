import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/controllers/add_pesanan_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/local_widgets/dialog_add_dokumentasi.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FormDokumentasi extends StatefulWidget {
  final String? id;

  const FormDokumentasi({Key? key, this.id}) : super(key: key);

  @override
  State<FormDokumentasi> createState() => _FormDokumentasiState();
}

class _FormDokumentasiState extends State<FormDokumentasi> {
  List<Widget> children = [];
  List<Widget> child = [];
  final controller = Get.find<AddPesananController>();

  @override
  void initState() {
    super.initState();
    children.add(
      ElevatedButton(
        onPressed: addFoto,
        child: const Text("TAMBAH"),
      ),
    );
    refresh();
  }

  void addFoto() async {
    String? hasil = await showDialog(
      context: context,
      builder: (ctx) => const DialogAddDokumentasi(),
      barrierDismissible: false,
    );
    if (hasil != null) {
      final ImagePicker _picker = ImagePicker();
      XFile? image;
      if (hasil == "gallery") {
        image = await _picker.pickImage(source: ImageSource.gallery);
      } else if (hasil == "camera") {
        image = await _picker.pickImage(source: ImageSource.camera);
      }

      if (image != null) {
        var fileName =
            DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '');
        Reference ref = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = ref.putFile(File(image.path));
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        log(downloadUrl);
        controller.fotoUrl.add(downloadUrl);
      }
    }

    refresh();
  }

  Widget imageCard(String url) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          Image.network(
            url,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const CircularProgressIndicator();
            },
          ),
          TextButton(
              onPressed: () async {
                bool confirm = await showConfirmationDeleteDialog(context);
                if (confirm) {
                  controller.fotoUrl.removeWhere((element) => element == url);
                  refresh();
                }
              },
              child: const Text("Hapus")),
        ],
      ),
    );
  }

  Future<List<Widget>> getList() async {
    List<Widget> child = [];
    for (var e in controller.fotoUrl) {
      child.add(imageCard(e));
    }
    return child;
  }

  void refresh() async {
    await getList().then((value) => child = value).whenComplete(() {
      setState(() {
        children.replaceRange(1, children.length, child);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
