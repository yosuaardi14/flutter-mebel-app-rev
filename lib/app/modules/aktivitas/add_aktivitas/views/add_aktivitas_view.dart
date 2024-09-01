import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/controllers/add_aktivitas_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/local_widgets/add_aktivitas_form.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/views/base_view.dart';

class AddAktivitasPage extends StatefulWidget {
  final String? id;
  const AddAktivitasPage({super.key, this.id});

  @override
  State<AddAktivitasPage> createState() => AddAktivitasController();
}

class AddAktivitasView extends StatelessWidget {
  final AddAktivitasController state;
  const AddAktivitasView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.id != null && state.detail.value!.isEmpty) {
      state.getData(state.id!);
    }
    return BaseView(
      state: state,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${state.id == null ? 'Tambah' : 'Edit'} Aktivitas"),
          centerTitle: true,
        ),
        body: Center(
          child: FormBuilder(
            key: state.formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoaderBooleanNotifierWidget(
                isLoading: state.isLoading,
                child: ValueListenableBuilder(
                  valueListenable: state.detail,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: AddAktivitasForm(
                            id: state.id,
                            detail: value,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            state.simpan(context);
                          },
                          child: const Text("SIMPAN"),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
