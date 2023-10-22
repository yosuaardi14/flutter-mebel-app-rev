import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/data/services/currency_input_formatter.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_bahan_baku/controllers/detail_bahan_baku_controller.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class DialogAddStokBahanBaku extends StatefulWidget {
  Map<String, dynamic> bahanBaku;
  DialogAddStokBahanBaku({Key? key, required this.bahanBaku}) : super(key: key);

  @override
  State<DialogAddStokBahanBaku> createState() => _DialogAddStokBahanBakuState();
}

class _DialogAddStokBahanBakuState extends State<DialogAddStokBahanBaku> {
  final controller = Get.find<DetailBahanBakuController>();

  static final _formKey = GlobalKey<FormBuilderState>();

  void simpan() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> hasil = {};
      hasil["id"] = widget.bahanBaku["id"];
      hasil["harga"] = _formKey.currentState!.value["harga"];
      hasil["jumlah"] = _formKey.currentState!.value["jumlah"];
      hasil["stok"] = widget.bahanBaku["stok"];
      hasil["histori-tambah"] = widget.bahanBaku["histori-tambah"];

      bool confirm = await showConfirmationAddDialog(context);
      if (confirm) {
        controller.addStok(hasil);
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
    return AlertDialog(
      title: const Text("Tambah Stok"),
      content: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  elevation: 1,
                  child: ListTile(
                    title: Text(widget.bahanBaku["nama"]),
                    subtitle: Text(
                      "Tersedia: ${widget.bahanBaku["stok"]}",
                      style: TextStyle(
                          color: getTextColor(widget.bahanBaku["stok"]),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                CustomFormField(
                  required: true,
                  child: FormBuilderTextField(
                    name: "harga",
                    initialValue: "0",
                    valueTransformer: (val) {
                      return currencyToInt(val);
                    },
                    validator: FormBuilderValidators.required(
                        errorText: requiredError()),
                    inputFormatters: [CurrencyInputFormatter()],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      errorMaxLines: 2,
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: "Harga",
                      prefixIcon: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                        child: Text('Rp'),
                      ),
                    ),
                  ),
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
                      FormBuilderValidators.min( 1,
                          errorText: minError(1))
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
