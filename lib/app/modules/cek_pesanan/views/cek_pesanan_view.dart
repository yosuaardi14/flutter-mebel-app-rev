import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/controllers/cek_pesanan_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/local_widgets/informasi_pesanan_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/local_widgets/pemesan_card.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/local_widgets/progress_pesanan_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CekPesananPage extends StatefulWidget {
  const CekPesananPage({super.key});

  @override
  State<CekPesananPage> createState() => CekPesananController();
}

class CekPesananView extends StatelessWidget {
  final CekPesananController state;
  const CekPesananView({super.key, required this.state});

  Widget imageCard(String url) {
    return Card(
      elevation: 5,
      child: Image.network(url),
    );
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.id != null)
                  Expanded(
                    child: LoaderBooleanNotifierWidget(
                      isLoading: state.isLoading,
                      child: ValueListenableBuilder(
                        valueListenable: state.detail,
                        builder: (context, detail, child) {
                          if (detail?.isEmpty ?? false) {
                            return const SizedBox();
                          }
                          return ListView(
                            children: [
                              InformasiPesananCard(
                                title: "Informasi Pesanan",
                                data: detail?["info"],
                              ),
                              PemesanCard(
                                title: "Pemesan",
                                data: detail?["pemesan"],
                              ),
                              const Card(
                                elevation: 3,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "Progress Pesanan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              ...detail?["progress"].map(
                                (e) => ProgressPesananCard(data: e),
                              ),
                              Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "${detail?["foto"].length == 0 ? "Belum Ada " : ""}Foto",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              ...detail?["foto"].map((e) => imageCard(e)),
                            ],
                          );
                        },
                      ),
                    ),
                    // GetBuilder<CekPesananController>(
                    //   init: controller,
                    //   builder: (val) => ListView(
                    //     children: val.isLoading.value
                    //         ? [const Center(child: CircularProgressIndicator())]
                    //         : val.detail!.isEmpty || val.detail == null
                    //             ? [
                    //                 const Center(
                    //                     child: Text("Data tidak ditemukan"))
                    //               ]
                    //             : [
                    //                 InformasiPesananCard(
                    //                     title: "Informasi Pesanan",
                    //                     data: val.detail!["info"]),
                    //                 PemesanCard(
                    //                     title: "Pemesan",
                    //                     data: val.detail!["pemesan"]),
                    //                 const Card(
                    //                   elevation: 3,
                    //                   child: Padding(
                    //                     padding: EdgeInsets.all(10.0),
                    //                     child: Text(
                    //                       "Progress Pesanan",
                    //                       style: TextStyle(
                    //                           fontWeight: FontWeight.bold,
                    //                           fontSize: 20),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 ...val.detail!["progress"].map(
                    //                   (e) => ProgressPesananCard(data: e),
                    //                 ),
                    //                 Card(
                    //                   elevation: 3,
                    //                   child: Padding(
                    //                     padding: const EdgeInsets.all(10.0),
                    //                     child: Text(
                    //                       "${val.detail!["foto"].length == 0 ? "Belum Ada " : ""}Foto",
                    //                       style: const TextStyle(
                    //                           fontWeight: FontWeight.bold,
                    //                           fontSize: 20),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 ...val.detail!["foto"]
                    //                     .map((e) => imageCard(e)),
                    //               ],
                    //   ),
                    // ),
                  ),
                FormBuilder(
                  key: state.formKey,
                  child: CustomFormField(
                    child: FormBuilderTextField(
                      name: "id",
                      validator: FormBuilderValidators.required(
                        errorText: requiredError(),
                      ),
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
                  width: mediaQuery.width,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: state.onCari,
                    child: const Text("CARI"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
