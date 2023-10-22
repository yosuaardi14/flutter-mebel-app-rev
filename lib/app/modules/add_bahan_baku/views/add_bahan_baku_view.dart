import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/data/services/currency_input_formatter.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';

import '../controllers/add_bahan_baku_controller.dart';

class AddBahanBakuView extends GetView<AddBahanBakuController> {
  final String? id;
  const AddBahanBakuView({Key? key, this.id}) : super(key: key);

  static final _formKey = GlobalKey<FormBuilderState>();

  void simpan(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      bool hasil = id == null
          ? await showConfirmationAddDialog(context)
          : await showConfirmationEditDialog(context);
      if (hasil) {
        _formKey.currentState!.save();
        controller.simpan(id, _formKey.currentState!.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (id != null && controller.detail!.isEmpty) controller.getData(id!);
    return GetBuilder<AddBahanBakuController>(
      init: controller,
      builder: (AddBahanBakuController val) => Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text("${id == null ? 'Tambah' : 'Edit'} Bahan Baku"),
              centerTitle: true,
            ),
            body: Center(
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: val.isLoading.value
                        ? [
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          ]
                        : [
                            CustomFormField(
                              required: true,
                              child: FormBuilderTextField(
                                name: "nama",
                                initialValue:
                                    initValCheck(id, val.detail!["nama"]),
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
                                name: "stok",
                                initialValue:
                                    initValCheck(id, val.detail!["stok"]),
                                valueTransformer: (val) {
                                  return valToInt(val);
                                },
                                enabled: id == null,
                                keyboardType: TextInputType.number,
                                validator: FormBuilderValidators.required(
                                  errorText: requiredError(),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: "Stok",
                                ),
                              ),
                            ),
                            CustomFormField(
                              required: true,
                              child: FormBuilderTextField(
                                name: "harga",
                                initialValue:
                                    initCurrencyCheck(id, val.detail!["harga"]),
                                // id != null ? val.detail!["harga"] : null,
                                valueTransformer: (val) {
                                  return currencyToInt(val);
                                },
                                validator: FormBuilderValidators.required(
                                  errorText: requiredError(),
                                ),
                                inputFormatters: [CurrencyInputFormatter()],
                                enabled: id == null,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: "Harga",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 12),
                                    child: Text('Rp'),
                                  ),
                                ),
                              ),
                            ),
                            CustomFormField(
                              child: FormBuilderTextField(
                                name: "merk",
                                initialValue:
                                    initValCheck(id, val.detail!["merk"]),
                                valueTransformer: (val) {
                                  return val ?? "";
                                },
                                decoration: const InputDecoration(
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: "Merk",
                                ),
                              ),
                            ),
                            CustomFormField(
                              child: FormBuilderTextField(
                                name: "deskripsi",
                                initialValue:
                                    initValCheck(id, val.detail!["deskripsi"]),
                                valueTransformer: (val) {
                                  return val ?? "";
                                },
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: "Deskripsi",
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                simpan(context);
                              },
                              child: const Text("SIMPAN"),
                            ),
                          ],
                  ),
                ),
              ),
            ),
          ),
          // ),
          if (val.isSaving)
            const Opacity(
              opacity: 0.7,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (val.isSaving) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
