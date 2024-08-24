import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/local_widgets/dialog_existing_pemesan.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class FormPemesan extends StatelessWidget {
  final String? id;
  final controller = Get.find<AddPesananController>();

  FormPemesan({Key? key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FormBuilder(
        key: AddPesananController.formKey[1],
        child: GetBuilder<AddPesananController>(
          init: controller,
          builder: (AddPesananController val) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: val.isLoading.value
                ? [
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  ]
                : [
                    if (isAdmin())
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic>? hasil = await showDialog(
                            context: context,
                            builder: (ctx) => DialogExistingPemesan(),
                          );
                          if (hasil != null) {
                            val.pemesan["id"] = hasil["id"];
                            AddPesananController
                                .formKey[1].currentState!.fields["nama"]
                                ?.didChange(hasil["nama"]);
                            AddPesananController
                                .formKey[1].currentState!.fields["nohp"]
                                ?.didChange(hasil["nohp"]);
                            AddPesananController
                                .formKey[1].currentState!.fields["alamat"]
                                ?.didChange(hasil["alamat"]);
                            val.newPembeli = false;
                          }
                          log(hasil.toString() + val.newPembeli.toString());
                        },
                        child: const Text("CARI PEMESAN"),
                      ),
                    CustomFormField(
                      required: true,
                      child: FormBuilderTextField(
                        name: "nama",
                        enabled: isAdmin(),
                        initialValue: initValCheck(
                            id, controller.detail!["pemesan"]?["nama"]),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: requiredError()),
                        ]),
                        decoration: const InputDecoration(
                          errorMaxLines: 2,
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "Nama",
                        ),
                      ),
                    ),
                    CustomFormField(
                      required: true,
                      child: FormBuilderTextField(
                        name: "nohp",
                        enabled: isAdmin(),
                        initialValue: initValNoHp(
                            id, controller.detail!["pemesan"]?["nohp"]),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: requiredError()),
                          FormBuilderValidators.numeric(
                              errorText: numericError()),
                        ]),
                        valueTransformer: (val) {
                          return "+62$val";
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          errorMaxLines: 2,
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 12),
                            child: Text('+62'),
                          ),
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "No HP",
                        ),
                      ),
                    ),
                    CustomFormField(
                      required: true,
                      child: FormBuilderTextField(
                        name: "alamat",
                        enabled: isAdmin(),
                        initialValue: initValCheck(
                            id, controller.detail!["pemesan"]?["alamat"]),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: requiredError()),
                        ]),
                        valueTransformer: (val) {
                          return val ?? "";
                        },
                        decoration: const InputDecoration(
                          errorMaxLines: 2,
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "Alamat",
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
