import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/data/services/currency_input_formatter.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/add_bahan_baku/controllers/add_bahan_baku_controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddBahanBakuForm extends StatelessWidget {
  final String? id;
  final Map<String, dynamic>? detail;
  final AddBahanBakuController state;

  const AddBahanBakuForm({
    super.key,
    this.id,
    this.detail,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomFormField(
          required: true,
          child: FormBuilderTextField(
            name: "nama",
            initialValue: initValCheck(id, detail?["nama"]),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: requiredError()),
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
            initialValue: initValCheck(id, detail?["stok"]),
            valueTransformer: (val) {
              return valToInt(val);
            },
            enabled: id == null,
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.required(
              errorText: requiredError(),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            initialValue: initCurrencyCheck(id, detail?["harga"]),
            // id != null ? detail?["harga"] : null,
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
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                child: Text('Rp'),
              ),
            ),
          ),
        ),
        CustomFormField(
          child: FormBuilderTextField(
            name: "merk",
            initialValue: initValCheck(id, detail?["merk"]),
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
            initialValue: initValCheck(id, detail?["deskripsi"]),
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
      ],
    );
  }
}
