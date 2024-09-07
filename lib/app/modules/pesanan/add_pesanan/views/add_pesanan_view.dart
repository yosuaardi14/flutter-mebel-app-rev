// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/views/base_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller_v2.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/local_widgets/form_bahan_baku.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/local_widgets/form_dokumentasi.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/local_widgets/form_informasi_pesanan.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/local_widgets/form_pemesan.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/local_widgets/form_progress_pesanan.dart';

class AddPesananPage extends StatefulWidget {
  final String? id;
  const AddPesananPage({super.key, this.id});

  @override
  State<AddPesananPage> createState() => AddPesananControllerV2();
}

class AddPesananView extends StatelessWidget {
  final AddPesananControllerV2 state;
  const AddPesananView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.id != null && state.detail.value!.isEmpty) {
      state.getData();
    }
    return BaseView(
      state: state,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${state.id == null ? 'Tambah' : 'Edit'} Pesanan"),
          centerTitle: true,
        ),
        body: LoaderBooleanNotifierWidget(
          isLoading: state.isLoading,
          child: ValueListenableBuilder(
            valueListenable: state.currentStep,
            builder: (context, currentStep, child) {
              return Stepper(
                type: StepperType.vertical,
                steps: listStep(),
                currentStep: currentStep,
                onStepContinue: () =>
                    state.onCheckStepContinue(listStep().length),
                onStepCancel: state.onStopCancel,
                onStepTapped: state.onStepTapped,
                controlsBuilder: (context, details) {
                  return Row(
                    children: [
                      if (currentStep != 0) ...[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: state.showOverlay.value
                                ? null
                                : details.onStepCancel,
                            child: const Text("SEBELUMNYA"),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: ElevatedButton(
                          onPressed: state.showOverlay.value
                              ? null
                              : details.onStepContinue,
                          child: Text(
                            currentStep == listStep().length - 1
                                ? "SIMPAN"
                                : "SELANJUTNYA",
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
    // SafeArea(
    // child: GetBuilder<AddPesananController>(
    // init: controller,
    // builder: (c) =>Stack(
    //   children: [
    //     Scaffold(
    //         appBar: AppBar(
    //           title: Text("${id == null ? 'Tambah' : 'Edit'} Pesanan"),
    //           centerTitle: true,
    //         ),
    //         body: c.isLoading.value
    //             ? const Center(child: CircularProgressIndicator())
    //             : Stepper(
    //                 type: StepperType.vertical,
    //                 steps: listStep(),
    //                 currentStep: controller.currentStep,
    //                 onStepContinue: () async {
    //                   if (controller.currentStep ==
    //                       listStep().length - 1) {
    //                     bool hasil = id == null
    //                         ? await showConfirmationAddDialog(context)
    //                         : await showConfirmationEditDialog(context);
    //                     if (hasil) controller.simpan(id);
    //                   } else {
    //                     controller.onStepContinue();
    //                   }
    //                 },
    //                 onStepCancel: () {
    //                   controller.onStopCancel();
    //                 },
    //                 onStepTapped: (index) {
    //                   if (id != null) controller.onStepTapped(index);
    //                 },
    //                 controlsBuilder: (context, details) {
    //                   return Row(
    //                     children: [
    //                       if (controller.currentStep != 0)
    //                         Expanded(
    //                           child: ElevatedButton(
    //                             onPressed: c.isSaving
    //                                 ? null
    //                                 : details.onStepCancel,
    //                             child: const Text("SEBELUMNYA"),
    //                           ),
    //                         ),
    //                       const SizedBox(width: 10),
    //                       Expanded(
    //                         child: ElevatedButton(
    //                           onPressed: c.isSaving
    //                               ? null
    //                               : details.onStepContinue,
    //                           child: Text(controller.currentStep ==
    //                                   listStep().length - 1
    //                               ? "SIMPAN"
    //                               : "SELANJUTNYA"),
    //                         ),
    //                       ),
    //                     ],
    //                   );
    //                 },
    //               )),
    //     if (c.isSaving)
    //       const Opacity(
    //         opacity: 0.7,
    //         child: ModalBarrier(dismissible: false, color: Colors.black),
    //       ),
    //     if (c.isSaving) const Center(child: CircularProgressIndicator()),
    //   ],
    // ),
    // ),
    // ),
    // );
  }

  List<Step> listStep() {
    return [
      Step(
        title: const Text('Informasi Pesanan'),
        content: FormInformasiPemesanan(state: state),
        isActive: state.currentStep.value >= 0,
        state: state.currentStep.value > 0
            ? StepState.complete
            : StepState.indexed,
      ),
      Step(
        title: const Text('Pemesan'),
        content: FormPemesan(state: state),
        isActive: state.currentStep.value >= 1,
        state: state.currentStep.value > 1
            ? StepState.complete
            : StepState.indexed,
      ),
      Step(
        title: const Text('Bahan Baku'),
        content: FormBahanBaku(state: state),
        isActive: state.currentStep.value >= 2,
        state: state.currentStep.value > 2
            ? StepState.complete
            : StepState.indexed,
      ),
      Step(
        title: const Text('Progress Pesanan'),
        content: FormProgressPesanan(state: state),
        isActive: state.currentStep.value >= 3,
        state: state.currentStep.value > 3
            ? StepState.complete
            : StepState.indexed,
      ),
      Step(
        title: const Text('Foto Dokumentasi'),
        content: FormDokumentasi(state: state),
        isActive: state.currentStep.value >= 4,
      )
    ];
  }
}
