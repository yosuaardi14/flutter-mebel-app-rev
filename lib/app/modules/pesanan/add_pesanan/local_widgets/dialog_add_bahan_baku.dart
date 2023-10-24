import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class DialogAddBahanBaku extends StatefulWidget {
  DialogAddBahanBaku({Key? key}) : super(key: key);

  @override
  State<DialogAddBahanBaku> createState() => _DialogAddBahanBakuState();
}

class _DialogAddBahanBakuState extends State<DialogAddBahanBaku> {
  final controller = Get.find<AddPesananController>();

  static final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> selectedBahanBaku = {};

  int stok = 0;

  void simpan() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> hasil = {};
      hasil["id"] = selectedBahanBaku["id"];
      hasil["nama"] = selectedBahanBaku["nama"];
      hasil["jumlah"] = _formKey.currentState!.value["jumlah"];
      bool confirm = await showConfirmationAddDialog(context);
      if (confirm) {
        log(hasil.toString());
        Navigator.pop(context, hasil);
      }
    }
  }

  Color getTextColor(int stok) {
    if (stok == 0) {
      return Colors.red;
    } else if (stok > 0 && stok <= 5) {
      return Colors.amber.shade900;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    // controller.getListBahanBaku();
    return AlertDialog(
      title: const Text("Tambah Bahan Baku"),
      content: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GetBuilder<AddPesananController>(
                  init: controller..getListBahanBaku(),
                  builder: (val) => CustomFormField(
                    required: true,
                    child: FormBuilderDropdown(
                      name: "nama",
                      items: controller.listBahanBaku!.isEmpty
                          ? []
                          : [
                              ...controller.listBahanBaku!.map(
                                (e) => DropdownMenuItem(
                                    child: Text(e["nama"]), value: e["id"]),
                              )
                            ],
                      onChanged: (value) {
                        setState(() {
                          selectedBahanBaku = controller.listBahanBaku!
                              .firstWhere((element) => value == element["id"]);
                          stok = selectedBahanBaku["stok"] +
                              (controller.oldBahanBaku[value] ?? 0);
                        });
                      },
                      validator: FormBuilderValidators.required(
                          errorText: requiredError()),
                      decoration: const InputDecoration(
                        errorMaxLines: 2,
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: "Nama Bahan Baku",
                      ),
                    ),
                  ),
                ),
                Text(
                  "Tersedia: $stok",
                  style: TextStyle(
                      color: getTextColor(stok), fontWeight: FontWeight.bold),
                ),
                CustomFormField(
                  required: true,
                  child: FormBuilderTextField(
                    name: "jumlah",
                    valueTransformer: (val) {
                      return valToInt(val);
                    },
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: requiredError()),
                      FormBuilderValidators.min(1, errorText: minError(1)),
                      FormBuilderValidators.max(stok, errorText: maxError(stok))
                    ]),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      errorMaxLines: 2,
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: "Jumlah",
                    ),
                  ),
                ),
              ],
            ),
          )),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text("Kembali")),
        const SizedBox(width: 10),
        TextButton(onPressed: simpan, child: const Text("Tambah")),
      ],
    );
  }
}
