import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/controllers/add_aktivitas_controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';

class AddAktivitasView extends GetView<AddAktivitasController> {
  final String? id;
  const AddAktivitasView({Key? key, this.id}) : super(key: key);

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
    return GetBuilder<AddAktivitasController>(
      init: controller,
      builder: (AddAktivitasController val) => Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text("${id == null ? 'Tambah' : 'Edit'} Aktivitas"),
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
                                name: "aktivitas",
                                initialValue:
                                    initValCheck(id, val.detail!["aktivitas"]),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: requiredError()),
                                ]),
                                decoration: const InputDecoration(
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: "Nama Aktivitas",
                                ),
                              ),
                            ),
                            CustomFormField(
                              required: true,
                              child: FormBuilderDropdown(
                                name: "tahap",
                                enabled: isAdmin(), //true,
                                initialValue:
                                    initValCheck(id, val.detail!["tahap"]),
                                items: const [
                                  DropdownMenuItem(
                                      child: Text("Pengukuran"),
                                      value: "pengukuran"),
                                  DropdownMenuItem(
                                      child: Text("Pemotongan"),
                                      value: "pemotongan"),
                                  DropdownMenuItem(
                                      child: Text("Perakitan"),
                                      value: "perakitan"),
                                  DropdownMenuItem(
                                      child: Text("Pemasangan"),
                                      value: "pemasangan"),
                                ],
                                validator: FormBuilderValidators.required(
                                    errorText: requiredError()),
                                decoration: const InputDecoration(
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: "Tahap",
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
