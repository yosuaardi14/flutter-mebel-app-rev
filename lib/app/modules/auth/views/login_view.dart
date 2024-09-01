import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/password_form_field.dart';
import 'package:flutter_mebel_app_rev/app/modules/auth/controllers/login_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/views/base_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginController();
}

class LoginView extends StatelessWidget {
  final LoginController state;
  const LoginView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    state.isPembeli = state.modalRoute?.settings.arguments == true;
    return BaseView(
      state: state,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Masuk ${state.isPembeli ? "- Pembeli" : ""}'),
          centerTitle: true,
        ),
        body: Center(
          child: FormBuilder(
            key: state.formKey,
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
                      visible: !state.isPembeli,
                      child: PasswordFormField(
                        name: "password",
                        label: "Kata Sandi",
                        validator: FormBuilderValidators.compose([
                          if (!state.isPembeli)
                            FormBuilderValidators.required(
                                errorText: requiredError()),
                        ]),
                        isDense: true,
                      ),
                    ),
                    SizedBox(
                      width: state.mediaQuery.size.width,
                      child: ElevatedButton(
                        onPressed: state.onLogin,
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
