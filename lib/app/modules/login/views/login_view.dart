import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/password_form_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  bool isPembeli = false;
  LoginView({Key? key, this.isPembeli = false}) : super(key: key);

  static final _formKey = GlobalKey<FormBuilderState>();

  void onLogin() async {
    String password = "";
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (!isPembeli) {
        password = _formKey.currentState!.value["password"];
      }
      log(password);
      await controller.login(
          _formKey.currentState!.value["nohp"], password, isPembeli);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: Center(
          child: FormBuilder(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomFormField(
                      child: FormBuilderTextField(
                        name: "nohp",
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
                    Visibility(
                      visible: !isPembeli,
                      child: PasswordFormField(
                        name: "password",
                        label: "Password",
                        validator: FormBuilderValidators.compose([
                          if (!isPembeli)
                            FormBuilderValidators.required(
                                errorText: requiredError()),
                        ]),
                        isDense: true,
                      ),
                    ),
                    SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: onLogin,
                        child: const Text("MASUK"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
