import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/password_form_field.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/add_user/controllers/add_user_controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddUserForm extends StatelessWidget {
  final String? id;
  final Map<String, dynamic>? detail;
  final AddUserController state;
  const AddUserForm({super.key, this.id, this.detail, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomFormField(
          required: true,
          child: FormBuilderTextField(
            name: "nama",
            initialValue: initValCheck(id, detail!["nama"]),
            validator:
                FormBuilderValidators.required(errorText: requiredError()),
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
            initialValue: initValNoHp(id, detail!["nohp"]),
            keyboardType: TextInputType.number,
            validator:
                FormBuilderValidators.required(errorText: requiredError()),
            valueTransformer: (val) {
              return "+62$val";
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              errorMaxLines: 2,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
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
            initialValue: initValCheck(id, detail!["role"]),
            items: const [
              DropdownMenuItem(value: "Pekerja", child: Text("Pekerja")),
              DropdownMenuItem(value: "Admin", child: Text("Admin")),
              DropdownMenuItem(value: "Pembeli", child: Text("Pembeli")),
            ],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: requiredError()),
            ]),
            onChanged: (value) {
              state.setState(() {
                state.role = value;
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
          required: state.role != "Pembeli",
          initialValue: initValCheck(id, detail!["password"]),
          validator: FormBuilderValidators.compose([
            if (state.role != "Pembeli")
              FormBuilderValidators.required(errorText: requiredError()),
          ]),
          isDense: true,
        ),
        CustomFormField(
          child: FormBuilderTextField(
            name: "alamat",
            initialValue: initValCheck(id, detail!["alamat"]),
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
    );
  }
}
