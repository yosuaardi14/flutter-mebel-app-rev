import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/add_bahan_baku/controllers/add_bahan_baku_controller.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/add_bahan_baku/local_widgets/add_bahan_baku_form.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/views/base_view.dart';

class AddBahanBakuPage extends StatefulWidget {
  final String? id;
  const AddBahanBakuPage({super.key, this.id});

  @override
  State<AddBahanBakuPage> createState() => AddBahanBakuController();
}

class AddBahanBakuView extends StatelessWidget {
  final AddBahanBakuController state;
  const AddBahanBakuView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.id != null && state.detail.value!.isEmpty) {
      state.getData();
    }
    return BaseView(
      state: state,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${state.id == null ? 'Tambah' : 'Edit'} Bahan Baku"),
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
                          child: AddBahanBakuForm(
                            id: state.id,
                            detail: value,
                            state: state,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: state.simpan,
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
