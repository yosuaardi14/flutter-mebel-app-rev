import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller_v2.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormPemesan extends StatelessWidget {
  final AddPesananControllerV2 state;
  const FormPemesan({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FormBuilder(
        key: AddPesananControllerV2.formKey[1],
        child: LoaderBooleanNotifierWidget(
          isLoading: state.isLoading,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isAdmin())
                ElevatedButton.icon(
                  onPressed: state.showDialogCariPemesan,
                  icon: const Icon(Icons.search),
                  label: const Text("CARI PEMESAN"),
                ),
              CustomFormField(
                required: true,
                child: FormBuilderTextField(
                  name: "nama",
                  enabled: isAdmin(),
                  initialValue: initValCheck(
                      state.id, state.detail.value?["pemesan"]?["nama"]),
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
                  name: "nohp",
                  enabled: isAdmin(),
                  initialValue: initValNoHp(
                      state.id, state.detail.value?["pemesan"]?["nohp"]),
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: requiredError()),
                    // FormBuilderValidators.numeric(errorText: numericError()),
                  ]),
                  valueTransformer: (val) {
                    return "+62$val";
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    errorMaxLines: 2,
                    prefixIcon: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 12),
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
                      state.id, state.detail.value?["pemesan"]?["alamat"]),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: requiredError()),
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
