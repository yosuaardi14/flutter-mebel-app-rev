import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/local_widgets/form_bahan_baku.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/local_widgets/form_dokumentasi.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/local_widgets/form_informasi_pesanan.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/local_widgets/form_pemesan.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/local_widgets/form_progress_pesanan.dart';

import 'package:get/get.dart';

import '../controllers/add_pesanan_controller.dart';

class AddPesananView extends GetView<AddPesananController> {
  final String? id;

  const AddPesananView({Key? key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (id != null && controller.detail!.isEmpty) controller.getData(id!);
    return SafeArea(
      child: GetBuilder<AddPesananController>(
        init: controller,
        builder: (c) => Stack(
          children: [
            Scaffold(
                appBar: AppBar(
                  title: Text("${id == null ? 'Tambah' : 'Edit'} Pesanan"),
                  centerTitle: true,
                ),
                body: c.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Stepper(
                        type: StepperType.vertical,
                        steps: buildStep(),
                        currentStep: controller.currentStep,
                        onStepContinue: () async {
                          if (controller.currentStep ==
                              buildStep().length - 1) {
                            bool hasil = id == null
                                ? await showConfirmationAddDialog(context)
                                : await showConfirmationEditDialog(context);
                            if (hasil) controller.simpan(id);
                          } else {
                            controller.onStepContinue();
                          }
                        },
                        onStepCancel: () {
                          controller.onStopCancel();
                        },
                        onStepTapped: (index) {
                          if (id != null) controller.onStepTapped(index);
                        },
                        controlsBuilder: (context, details) {
                          return Row(
                            children: [
                              if (controller.currentStep != 0)
                                Expanded(
                                  child: ElevatedButton(
                                    child: const Text("SEBELUMNYA"),
                                    onPressed: c.isSaving
                                        ? null
                                        : details.onStepCancel,
                                  ),
                                ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  child: Text(controller.currentStep ==
                                          buildStep().length - 1
                                      ? "SIMPAN"
                                      : "SELANJUTNYA"),
                                  onPressed: c.isSaving
                                      ? null
                                      : details.onStepContinue,
                                ),
                              ),
                            ],
                          );
                        },
                      )),
            if (c.isSaving)
              const Opacity(
                opacity: 0.7,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (c.isSaving) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  List<Step> buildStep() {
    return [
      Step(
          title: const Text('Informasi Pesanan'),
          content: FormInformasiPemesanan(id: id),
          isActive: controller.currentStep >= 0,
          state: controller.currentStep > 0
              ? StepState.complete
              : StepState.indexed),
      Step(
          title: const Text('Pemesan'),
          content: FormPemesan(id: id),
          isActive: controller.currentStep >= 1,
          state: controller.currentStep > 1
              ? StepState.complete
              : StepState.indexed),
      Step(
          title: const Text('Bahan Baku'),
          content: FormBahanBaku(id: id),
          isActive: controller.currentStep >= 2,
          state: controller.currentStep > 2
              ? StepState.complete
              : StepState.indexed),
      Step(
          title: const Text('Progress Pesanan'),
          content: FormProgressPesanan(id: id),
          isActive: controller.currentStep >= 3,
          state: controller.currentStep > 3
              ? StepState.complete
              : StepState.indexed),
      Step(
          title: const Text('Foto Dokumentasi'),
          content: FormDokumentasi(id: id),
          isActive: controller.currentStep >= 4)
    ];
  }
}
