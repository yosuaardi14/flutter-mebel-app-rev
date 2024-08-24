import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class DialogExistingPemesan extends StatefulWidget {
  DialogExistingPemesan({Key? key}) : super(key: key);

  @override
  State<DialogExistingPemesan> createState() => _DialogExistingPemesanState();
}

class _DialogExistingPemesanState extends State<DialogExistingPemesan> {
  final controller = Get.find<AddPesananController>();
  static final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic>? selectedUser;

  void simpan() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> hasil = {};
      hasil.addAll(_formKey.currentState!.value);
      hasil["nama"] = selectedUser!["nama"];
      hasil["id"] = selectedUser!["id"];
      hasil["nohp"] = selectedUser!["nohp"].replaceAll("+62", "");
      hasil["alamat"] = selectedUser!["alamat"];
      bool confirm = await showConfirmationAddDialog(context);
      if (confirm) {
        log(hasil.toString());
        Navigator.pop(context, hasil);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cari Pemesan"),
      content: FormBuilder(
        key: _formKey,
        child: GetBuilder<AddPesananController>(
          init: controller..getListUser(),
          builder: (val) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomFormField(
                required: true,
                child: FormBuilderDropdown(
                  name: "nama",
                  initialValue: null,
                  items: controller.listUser!.isEmpty
                      ? []
                      : [
                          ...controller.listUser!.map(
                            (e) => DropdownMenuItem(
                              child: Text(e["nama"]),
                              value: e["id"],
                            ),
                          )
                        ],
                  validator: FormBuilderValidators.required(
                      errorText: requiredError()),
                  decoration: const InputDecoration(
                    errorMaxLines: 2,
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: "Nama Pembeli",
                  ),
                  onChanged: (e) {
                    setState(() {
                      selectedUser = controller.listUser!
                          .firstWhere((element) => element["id"] == e);
                      log(selectedUser.toString());
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text("Role: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(selectedUser?["role"] ?? ""),
                ],
              ),
              const SizedBox(height: 15),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text("No HP: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(selectedUser?["nohp"] ?? ""),
                ],
              ),
              const SizedBox(height: 15),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text("Alamat: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(selectedUser?["alamat"] ?? ""),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text("Tidak")),
        const SizedBox(width: 10),
        TextButton(onPressed: simpan, child: const Text("Ya")),
      ],
    );
  }
}
