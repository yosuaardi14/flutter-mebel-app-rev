import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/local_widgets/informasi_pesanan_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/local_widgets/pemesan_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/local_widgets/progress_pesanan_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../controllers/cek_pesanan_controller.dart';

class CekPesananView extends GetView<CekPesananController> {
  String? id;
  CekPesananView({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormBuilderState>();

  Widget imageCard(String url) {
    return Card(
      elevation: 5,
      child: Image.network(url),
    );
  }

  void onCari(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      id = _formKey.currentState!.value["id"];
      controller.getData(id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cek Pesanan'),
          centerTitle: true,
        ),
        body: SizedBox(
          width: mediaQuery.width,
          height: mediaQuery.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (id != null)
                Expanded(
                  child: GetBuilder<CekPesananController>(
                    init: controller,
                    builder: (val) => ListView(
                      children: val.isLoading.value
                          ? [const Center(child: CircularProgressIndicator())]
                          : val.detail!.isEmpty || val.detail == null
                              ? [
                                  const Center(
                                      child: Text("Data tidak ditemukan"))
                                ]
                              : [
                                  InformasiPesananCard(
                                      title: "Informasi Pesanan",
                                      data: val.detail!["info"]),
                                  PemesanCard(
                                      title: "Pemesan",
                                      data: val.detail!["pemesan"]),
                                  const Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        "Progress Pesanan",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  ...val.detail!["progress"].map(
                                    (e) => ProgressPesananCard(data: e),
                                  ),
                                  Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        (val.detail!["foto"].length == 0
                                                ? "Belum Ada "
                                                : "") +
                                            "Foto",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  ...val.detail!["foto"]
                                      .map((e) => imageCard(e)),
                                ],
                    ),
                  ),
                ),
              FormBuilder(
                key: _formKey,
                child: CustomFormField(
                  child: FormBuilderTextField(
                    name: "id",
                    validator: FormBuilderValidators.required(
                        errorText: requiredError()),
                    decoration: const InputDecoration(
                      errorMaxLines: 2,
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: "Kode Pesanan",
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: mediaQuery.width * 0.95,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    onCari(context);
                  },
                  child: const Text("CARI"),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
