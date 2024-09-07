import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller_v2.dart';

class FormDokumentasi extends StatefulWidget {
  final AddPesananControllerV2 state;

  const FormDokumentasi({super.key, required this.state});

  @override
  State<FormDokumentasi> createState() => _FormDokumentasiState();
}

class _FormDokumentasiState extends State<FormDokumentasi> {
  List<Widget> children = [];
  List<Widget> child = [];

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
    widget.state.showDialogAddDokumentasi(refresh);
    // String? hasil = await showDialog(
    //   context: context,
    //   builder: (ctx) => const DialogAddDokumentasi(),
    //   barrierDismissible: false,
    // );
    // if (hasil != null) {
    //   final ImagePicker picker = ImagePicker();
    //   XFile? image;
    //   if (hasil == "gallery") {
    //     image = await picker.pickImage(source: ImageSource.gallery);
    //   } else if (hasil == "camera") {
    //     image = await picker.pickImage(source: ImageSource.camera);
    //   }

    //   if (image != null) {
    //     var fileName =
    //         DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '');
    //     Reference ref = FirebaseStorage.instance.ref().child(fileName);
    //     UploadTask uploadTask = ref.putFile(File(image.path));
    //     TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    //     final downloadUrl = await snapshot.ref.getDownloadURL();
    //     log(downloadUrl);
    //     widget.state.fotoUrl.add(downloadUrl);
    //   }
    // }

    // refresh();
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
                widget.state.deleteDokumentasi(url, refresh);
              },
              child: const Text("Hapus")),
        ],
      ),
    );
  }

  Future<List<Widget>> getList() async {
    List<Widget> child = [];
    for (var e in widget.state.fotoUrl) {
      child.add(imageCard(e));
    }
    return child;
  }

  void refresh() async {
    getList().then((value) => child = value).whenComplete(() {
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
