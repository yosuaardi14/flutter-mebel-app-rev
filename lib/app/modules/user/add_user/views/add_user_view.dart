import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/password_form_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';

import '../controllers/add_user_controller.dart';

class AddUserView extends StatefulWidget {
  final String? id;
  const AddUserView({Key? key, this.id}) : super(key: key);

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  static final _formKey = GlobalKey<FormBuilderState>();
  final controller = Get.find<AddUserController>();

  void simpan(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      bool hasil = widget.id == null
          ? await showConfirmationAddDialog(context)
          : await showConfirmationEditDialog(context);
      if (hasil) {
        _formKey.currentState!.save();
        controller.simpan(widget.id, _formKey.currentState!.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id != null && controller.detail!.isEmpty) {
      controller.getData(widget.id!);
    }
    return SafeArea(
      child: GetBuilder<AddUserController>(
        init: controller,
        builder: (AddUserController val) => Stack(children: [
          Scaffold(
            appBar: AppBar(
              title: Text("${widget.id == null ? 'Tambah' : 'Edit'} User"),
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
                                initialValue: initValCheck(
                                    widget.id, val.detail!["nama"]),
                                validator: FormBuilderValidators.required(
                                    errorText: requiredError()),
                                decoration: const InputDecoration(
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: "Nama Lengkap",
                                ),
                              ),
                            ),
                            CustomFormField(
                              required: true,
                              child: FormBuilderTextField(
                                name: "nohp",
                                initialValue:
                                    initValNoHp(widget.id, val.detail!["nohp"]),
                                keyboardType: TextInputType.number,
                                validator: FormBuilderValidators.required(
                                    errorText: requiredError()),
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
                              child: FormBuilderDropdown(
                                name: "role",
                                initialValue: initValCheck(
                                    widget.id, val.detail!["role"]),
                                items: const [
                                  DropdownMenuItem(
                                      child: Text("Pekerja"), value: "Pekerja"),
                                  DropdownMenuItem(
                                      child: Text("Admin"), value: "Admin"),
                                  DropdownMenuItem(
                                      child: Text("Pembeli"), value: "Pembeli"),
                                ],
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: requiredError()),
                                ]),
                                onChanged: (value) {
                                  setState(() {
                                    val.role = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: "Role",
                                ),
                              ),
                            ),
                            PasswordFormField(
                              name: "password",
                              label: "Password",
                              required: val.role != "Pembeli",
                              initialValue: initValCheck(
                                  widget.id, val.detail!["password"]),
                              validator: FormBuilderValidators.compose([
                                if (val.role != "Pembeli")
                                  FormBuilderValidators.required(
                                      errorText: requiredError()),
                              ]),
                              isDense: true,
                            ),
                            CustomFormField(
                              child: FormBuilderTextField(
                                name: "alamat",
                                initialValue: initValCheck(
                                    widget.id, val.detail!["alamat"]),
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
          if (val.isSaving)
            const Opacity(
              opacity: 0.7,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (val.isSaving) const Center(child: CircularProgressIndicator()),
        ]),
      ),
    );
  }
}
