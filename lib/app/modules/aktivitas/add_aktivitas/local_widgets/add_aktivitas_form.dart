import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddAktivitasForm extends StatelessWidget {
  final String? id;
  final Map<String, dynamic>? detail;
  const AddAktivitasForm({super.key, this.id, this.detail});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomFormField(
          required: true,
          child: FormBuilderTextField(
            name: "aktivitas",
            initialValue: initValCheck(id, detail!["aktivitas"]),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: requiredError()),
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
            initialValue: initValCheck(id, detail!["tahap"]),
            items: const [
              DropdownMenuItem(
                value: "pengukuran",
                child: Text("Pengukuran"),
              ),
              DropdownMenuItem(
                value: "pemotongan",
                child: Text("Pemotongan"),
              ),
              DropdownMenuItem(
                value: "perakitan",
                child: Text("Perakitan"),
              ),
              DropdownMenuItem(
                value: "pemasangan",
                child: Text("Pemasangan"),
              ),
            ],
            validator:
                FormBuilderValidators.required(errorText: requiredError()),
            decoration: const InputDecoration(
              errorMaxLines: 2,
              border: OutlineInputBorder(),
              isDense: true,
              hintText: "Tahap",
            ),
          ),
        ),
      ],
    );
  }
}
