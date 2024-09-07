// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller_v2.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class DialogAddProgressPesanan extends StatefulWidget {
  final int? id;
  final AddPesananControllerV2 state;
  const DialogAddProgressPesanan({super.key, this.id, required this.state});

  @override
  State<DialogAddProgressPesanan> createState() =>
      _DialogAddProgressPesananState();
}

class _DialogAddProgressPesananState extends State<DialogAddProgressPesanan> {
  static final _formKey = GlobalKey<FormBuilderState>();
  final selectedPekerja = ValueNotifier<Map<String, dynamic>>({});
  final selectedExistingAktivitas = ValueNotifier<Map<String, dynamic>>({});
  // Map<String, dynamic> selectedPekerja = {};
  // Map<String, dynamic> selectedExistingAktivitas.value = {};
  bool isNew = false;
  final panjangVisible = ValueNotifier<bool>(false);
  final jumlahVisible = ValueNotifier<bool>(false);
  final tahap = ValueNotifier<String>("all");
  // bool panjangVisible.value = false;
  // bool jumlahVisible.value = false;
  // String tahap = "all";

  void simpan() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> hasil = {};
      hasil["tahap"] = _formKey.currentState!.value["tahap"];
      if (isNew) {
        hasil["aktivitas"] = _formKey.currentState!.value["aktivitas"];
      } else {
        hasil["aktivitas"] = {
          "id": selectedExistingAktivitas.value["id"],
          "nama": selectedExistingAktivitas.value["aktivitas"],
        };

        //_formKey.currentState!.value["extaktivitas"];
      }
      hasil["persentase"] = _formKey.currentState!.value["persentase"];
      //dalam ubah ke menit
      if (_formKey.currentState!.value["waktu"] == "hari") {
        hasil["waktupengerjaan"] = _formKey.currentState!.value["durasi"] * 420;
      } else if (_formKey.currentState!.value["waktu"] == "jam") {
        hasil["waktupengerjaan"] = _formKey.currentState!.value["durasi"] * 60;
      } else {
        hasil["waktupengerjaan"] = _formKey.currentState!.value["durasi"];
      }

      if (selectedExistingAktivitas.value.containsKey("panjang")) {
        hasil["panjang"] = _formKey.currentState!.value["panjang"];
      }
      if (selectedExistingAktivitas.value.containsKey("jumlah")) {
        hasil["jumlah"] = _formKey.currentState!.value["jumlah"];
      }

      hasil["tanggalSelesai"] = _formKey.currentState!.value["tanggalSelesai"];
      hasil["perkiraanSelesai"] =
          _formKey.currentState!.value["perkiraanSelesai"];
      if (hasil["persentase"] == 100 && hasil["tanggalSelesai"] == "") {
        hasil["tanggalSelesai"] = dateToString(DateTime.now());
      }
      hasil["catatan"] = _formKey.currentState!.value["catatan"];
      hasil["pekerja"] = selectedPekerja;
      bool confirm = widget.id == null
          ? await showConfirmationAddDialog(context)
          : await showConfirmationEditDialog(context);
      if (confirm) {
        if (isNew) {
          //simpan ke aktivitas collection
        }
        log(hasil.toString());
        Navigator.pop(context, hasil);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tambah Progress Pesanan"),
      content: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   children: [
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () {
              //           _formKey.currentState!.reset();
              //           setState(() {
              //             selectedExistingAktivitas.value = {};
              //             isNew = true;
              //           });
              //         },
              //         child: const Text("Baru"),
              //         style: ElevatedButton.styleFrom(
              //             primary: isNew ? Colors.blue : Colors.grey),
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () {
              //           _formKey.currentState!.reset();
              //           setState(() {
              //             isNew = false;
              //           });
              //         },
              //         child: const Text("Sudah Ada"),
              //         style: ElevatedButton.styleFrom(
              //             primary: !isNew ? Colors.blue : Colors.grey),
              //       ),
              //     ),
              //   ],
              // ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomFormField(
                        required: true,
                        child: FormBuilderDropdown(
                          name: "tahap",
                          enabled: isAdmin(), //true,
                          initialValue: initValProgressTahap(
                              widget.id, widget.state.progressPesanan),
                          items: const [
                            DropdownMenuItem(
                                value: "pengukuran", child: Text("Pengukuran")),
                            DropdownMenuItem(
                                value: "pemotongan", child: Text("Pemotongan")),
                            DropdownMenuItem(
                                value: "perakitan", child: Text("Perakitan")),
                            DropdownMenuItem(
                                value: "pemasangan", child: Text("Pemasangan")),
                          ],
                          onChanged: (val) {
                            // setState(() {
                            tahap.value = val;
                            // });
                            panjangVisible.value = false;
                            jumlahVisible.value = false;
                            // .didChange("");
                            log(isNew.toString());
                            _formKey.currentState?.fields["extaktivitas"]
                                ?.reset();
                            if (!isNew) {
                              widget.state.getListAktivitas(val);
                              // widget.state.update();
                            }
                          },
                          validator: FormBuilderValidators.required(
                              errorText: requiredError()),
                          decoration: const InputDecoration(
                            errorMaxLines: 2,
                            border: OutlineInputBorder(),
                            isDense: true,
                            hintText: "Tahap",
                          ),
                        ),
                      ),
                      // if (isNew)
                      // CustomFormField(
                      //   required: true,
                      //   child: FormBuilderTextField(
                      //     name: "aktivitas",
                      //     initialValue: initValProgress(widget.id,
                      //         widget.state.progressPesanan, "aktivitas"),
                      //     valueTransformer: (val) {
                      //       return val ?? "";
                      //     },
                      //     validator: FormBuilderValidators.required(
                      //         errorText: requiredError()),
                      //     decoration: const InputDecoration(
                      //       errorMaxLines: 2,
                      //       border: OutlineInputBorder(),
                      //       isDense: true,
                      //       hintText: "Aktivitas",
                      //     ),
                      //   ),
                      // )
                      // else // TODO
                      // GetBuilder<AddPesananController>(
                      //   init: widget.state..getListAktivitas(tahap),
                      //   builder: (val) =>
                      ValueListenableBuilder(
                        valueListenable: widget.state.listAktivitas,
                        builder: (context, listAktivitas, child) {
                          // widget.state.getListAktivitas(tahap);
                          return CustomFormField(
                            required: true,
                            child: FormBuilderDropdown(
                              name: "extaktivitas",
                              enabled: isAdmin(),
                              initialValue: (listAktivitas?.isNotEmpty ?? false)
                                  ? initValProgress(widget.id,
                                      widget.state.progressPesanan, "aktivitas")
                                  : null,
                              items: [
                                ...?listAktivitas?.map((e) => DropdownMenuItem(
                                    value: e["id"],
                                    child: Text(e["aktivitas"])))
                              ],
                              validator: FormBuilderValidators.required(
                                  errorText: requiredError()),
                              decoration: const InputDecoration(
                                errorMaxLines: 2,
                                border: OutlineInputBorder(),
                                isDense: true,
                                hintText: "Aktivitas",
                              ),
                              onChanged: (value) {
                                // log(val.toString());
                                // TODO
                                // setState(() {
                                panjangVisible.value = false;
                                // });
                                // setState(() {
                                jumlahVisible.value = false;
                                // });
                                if (value == null) {
                                  return;
                                }
                                // setState(() {
                                var temp = listAktivitas?.firstWhere(
                                    (element) => value == element["id"]);
                                selectedExistingAktivitas.value = temp ?? {};

                                log(selectedExistingAktivitas.value.toString());
                                // });
                                if (selectedExistingAktivitas.value
                                    .containsKey("panjang")) {
                                  // setState(() {
                                  panjangVisible.value = true;
                                  // });
                                  // setState(() {
                                  _formKey.currentState?.fields["panjang"]
                                      ?.didChange(selectedExistingAktivitas
                                          .value["panjang"]
                                          .toString());
                                  _formKey.currentState?.fields["satuanP"]
                                      ?.didChange("cm");
                                  // });
                                }
                                if (selectedExistingAktivitas.value
                                    .containsKey("jumlah")) {
                                  // setState(() {
                                  jumlahVisible.value = true;
                                  // });
                                  // setState(() {
                                  _formKey.currentState?.fields["jumlah"]
                                      ?.didChange(selectedExistingAktivitas
                                          .value["jumlah"]
                                          .toString());
                                  // });
                                }
                                // setState(() {
                                _formKey.currentState?.fields["durasi"]
                                    ?.didChange(selectedExistingAktivitas
                                        .value["durasi"]
                                        .toString());
                                _formKey.currentState?.fields["waktu"]
                                    ?.didChange("menit");
                                // });
                                // if (selectedExistingAktivitas.value
                                //     .containsKey("durasi")) {

                                // }
                              },
                              onSaved: (value) {
                                // setState(() {
                                selectedExistingAktivitas.value = listAktivitas!
                                    .firstWhere(
                                        (element) => value == element["id"]);
                                // });
                              },
                            ),
                          );
                        },
                      ),
                      // ),
                      // TODO
                      // GetBuilder<AddPesananController>(
                      //   init: widget.state..getListPekerja(),
                      //   builder: (val) =>

                      ValueListenableBuilder(
                        valueListenable: widget.state.listPekerja,
                        builder: (context, listPekerja, child) {
                          return CustomFormField(
                            required: true,
                            child: FormBuilderDropdown(
                              name: "pekerja",
                              enabled: isAdmin(),
                              initialValue: (listPekerja?.isNotEmpty ?? false)
                                  ? initValProgress(widget.id,
                                      widget.state.progressPesanan, "pekerja")
                                  : null,
                              items: [
                                ...?listPekerja?.map((e) => DropdownMenuItem(
                                    value: e["id"], child: Text(e["nama"])))
                              ],
                              validator: FormBuilderValidators.required(
                                  errorText: requiredError()),
                              decoration: const InputDecoration(
                                errorMaxLines: 2,
                                border: OutlineInputBorder(),
                                isDense: true,
                                hintText: "Nama Pekerja",
                              ),
                              onChanged: (value) {
                                // log(val.toString());
                                // setState(() {
                                selectedPekerja.value = listPekerja!.firstWhere(
                                    (element) => value == element["id"]);
                                // });
                              },
                              onSaved: (value) {
                                // setState(() {
                                selectedPekerja.value = listPekerja!.firstWhere(
                                    (element) => value == element["id"]);
                                // });
                              },
                            ),
                          );
                        },
                      ),
                      // ),
                      // if (panjangVisible)
                      ValueListenableBuilder(
                        valueListenable: panjangVisible,
                        builder: (context, value, child) {
                          return Visibility(
                            visible: value,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomFormField(
                                    required: true,
                                    child: FormBuilderTextField(
                                      name: "panjang",
                                      initialValue: initValProgress(
                                          widget.id,
                                          widget.state.progressPesanan,
                                          "panjang"),
                                      valueTransformer: (val) {
                                        return valToInt(val);
                                      },
                                      validator: FormBuilderValidators.required(
                                          errorText: requiredError()),
                                      decoration: const InputDecoration(
                                        errorMaxLines: 2,
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        hintText: "Panjang",
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        if (val != null) {
                                          int? panjang = int.tryParse(val);
                                          if (panjang != null) {
                                            if (_formKey.currentState!
                                                    .fields["satuanP"]!.value ==
                                                "m") {
                                              panjang = panjang * 100;
                                            }
                                            int durasi =
                                                ((selectedExistingAktivitas
                                                                    .value[
                                                                "durasi"] *
                                                            panjang) /
                                                        selectedExistingAktivitas
                                                            .value["panjang"])
                                                    .round();
                                            _formKey
                                                .currentState?.fields["durasi"]
                                                ?.didChange(durasi.toString());
                                          }
                                        } else {
                                          _formKey
                                              .currentState?.fields["durasi"]
                                              ?.didChange("0");
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: CustomFormField(
                                    required: true,
                                    child: FormBuilderDropdown(
                                      name: "satuanP",
                                      initialValue: initValProgress(
                                          widget.id,
                                          widget.state.progressPesanan,
                                          "satuanP"),
                                      items: const [
                                        DropdownMenuItem(
                                            value: "m", child: Text("meter")),
                                        DropdownMenuItem(
                                            value: "cm", child: Text("cm")),
                                      ],
                                      validator: FormBuilderValidators.required(
                                          errorText: requiredError()),
                                      decoration: const InputDecoration(
                                        errorMaxLines: 2,
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        hintText: "Satuan",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // if (jumlahVisible)
                      ValueListenableBuilder(
                        valueListenable: jumlahVisible,
                        builder: (context, value, child) {
                          return Visibility(
                            visible: value,
                            child: CustomFormField(
                              required: true,
                              child: FormBuilderTextField(
                                name: "jumlah",
                                initialValue: initValProgress(widget.id,
                                    widget.state.progressPesanan, "jumlah"),
                                valueTransformer: (val) {
                                  return valToInt(val);
                                },
                                validator: FormBuilderValidators.required(
                                    errorText: requiredError()),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: "Jumlah",
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    if (val != null) {
                                      int? jumlah = int.tryParse(val);
                                      if (jumlah != null) {
                                        int durasi = ((selectedExistingAktivitas
                                                        .value["durasi"] *
                                                    jumlah) /
                                                selectedExistingAktivitas
                                                    .value["jumlah"])
                                            .round();
                                        _formKey.currentState?.fields["durasi"]
                                            ?.didChange(durasi.toString());
                                      }
                                    } else {
                                      _formKey.currentState?.fields["durasi"]
                                          ?.didChange("0");
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      // CustomFormField(
                      //   required: true,
                      //   child: FormBuilderTextField(
                      //     name: "ukuran",
                      //     initialValue: initValProgress(
                      //         widget.id, widget.state.progressPesanan, "ukuran"),
                      //     valueTransformer: (val) {
                      //       return valToInt(val);
                      //     },
                      //     validator: FormBuilderValidators.required(
                      //         errorText: requiredError()),
                      //     decoration: const InputDecoration(
                      //       errorMaxLines: 2,
                      //       border: OutlineInputBorder(),
                      //       isDense: true,
                      //       hintText: "Ukuran",
                      //       helperText: "Contoh: 2m x 2m x 2m",
                      //     ),
                      //     onChanged: (value) {
                      //       if (!isNew && value != null) {
                      //         // String ukuran = selectedExistingAktivitas.value["ukuran"];
                      //         // RegExp regex = RegExp(r'\d+');
                      //         // var listUkuran = ukuran.split(regex);
                      //         // log(listUkuran[0]);
                      //         _formKey.currentState!.fields["durasi"]!
                      //             .didChange("10");
                      //         // var satuanUkuran
                      //         // var tempWaktu = waktu;
                      //         // selectedExistingAktivitas.value
                      //       }
                      //     },
                      //   ),
                      // ),
                      // if (tahap == "perakitan")
                      //   Row(
                      //     children: [
                      //       Expanded(
                      //         child: CustomFormField(
                      //           required: true,
                      //           child: FormBuilderTextField(
                      //             name: "panjang",
                      //             initialValue: initValProgress(widget.id,
                      //                 widget.state.progressPesanan, "panjang"),
                      //             valueTransformer: (val) {
                      //               return valToInt(val);
                      //             },
                      //             validator: FormBuilderValidators.required(
                      //                 context,
                      //                 errorText: requiredError()),
                      //             decoration: const InputDecoration(
                      //               errorMaxLines: 2,
                      //               border: OutlineInputBorder(),
                      //               isDense: true,
                      //               hintText: "Panjang",
                      //             ),
                      //             onChanged: (val) {
                      //               if (val != null) {
                      //                 int? panjang = int.tryParse(val);
                      //                 if (panjang != null) {
                      //                   int durasi = selectedExistingAktivitas.value[
                      //                           "durasi"] *
                      //                       panjang;
                      //                   _formKey.currentState!.fields["durasi"]!
                      //                       .didChange(durasi.toString());
                      //                 }
                      //               }
                      //             },
                      //           ),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: CustomFormField(
                      //           required: true,
                      //           child: FormBuilderDropdown(
                      //             name: "satuanP",
                      //             initialValue: initValProgress(widget.id,
                      //                 widget.state.progressPesanan, "satuanP"),
                      //             // valueTransformer: (val) {
                      //             //   return valToInt(val);
                      //             // },
                      //             items: const [
                      //               DropdownMenuItem(
                      //                   child: Text("meter"), value: "m"),
                      //               DropdownMenuItem(
                      //                   child: Text("cm"), value: "cm"),
                      //             ],
                      //             validator: FormBuilderValidators.required(
                      //                 context,
                      //                 errorText: requiredError()),
                      //             decoration: const InputDecoration(
                      //               errorMaxLines: 2,
                      //               border: OutlineInputBorder(),
                      //               isDense: true,
                      //               hintText: "Satuan",
                      //             ),
                      //             // onChanged: (val) {
                      //             //   if (val != null) {
                      //             //     int? jumlah = int.tryParse(val);
                      //             //     if (jumlah != null) {
                      //             //       int durasi = selectedExistingAktivitas.value[
                      //             //               "durasi"] *
                      //             //           jumlah;
                      //             //       _formKey.currentState!.fields["durasi"]!
                      //             //           .didChange(durasi.toString());
                      //             //     }
                      //             //   }
                      //             // },
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // if (tahap == "perakitan")
                      //   Row(
                      //     children: [
                      //       Expanded(
                      //         child: CustomFormField(
                      //           required: true,
                      //           child: FormBuilderTextField(
                      //             name: "lebar",
                      //             initialValue: initValProgress(widget.id,
                      //                 widget.state.progressPesanan, "lebar"),
                      //             valueTransformer: (val) {
                      //               return valToInt(val);
                      //             },
                      //             validator: FormBuilderValidators.required(
                      //                 context,
                      //                 errorText: requiredError()),
                      //             decoration: const InputDecoration(
                      //               errorMaxLines: 2,
                      //               border: OutlineInputBorder(),
                      //               isDense: true,
                      //               hintText: "Lebar",
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: CustomFormField(
                      //           required: true,
                      //           child: FormBuilderDropdown(
                      //             name: "satuanL",
                      //             initialValue: initValProgress(widget.id,
                      //                 widget.state.progressPesanan, "satuanL"),
                      //             // valueTransformer: (val) {
                      //             //   return valToInt(val);
                      //             // },
                      //             items: const [
                      //               DropdownMenuItem(
                      //                   child: Text("meter"), value: "m"),
                      //               DropdownMenuItem(
                      //                   child: Text("cm"), value: "cm"),
                      //               DropdownMenuItem(
                      //                   child: Text("mm"), value: "mm"),
                      //             ],
                      //             validator: FormBuilderValidators.required(
                      //                 context,
                      //                 errorText: requiredError()),
                      //             decoration: const InputDecoration(
                      //               errorMaxLines: 2,
                      //               border: OutlineInputBorder(),
                      //               isDense: true,
                      //               hintText: "Satuan",
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // if (tahap == "perakitan")
                      //   Row(
                      //     children: [
                      //       Expanded(
                      //         child: CustomFormField(
                      //           required: true,
                      //           child: FormBuilderTextField(
                      //             name: "tebal",
                      //             initialValue: initValProgress(widget.id,
                      //                 widget.state.progressPesanan, "tebal"),
                      //             valueTransformer: (val) {
                      //               return valToInt(val);
                      //             },
                      //             validator: FormBuilderValidators.required(
                      //                 context,
                      //                 errorText: requiredError()),
                      //             decoration: const InputDecoration(
                      //               errorMaxLines: 2,
                      //               border: OutlineInputBorder(),
                      //               isDense: true,
                      //               hintText: "Tebal",
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: CustomFormField(
                      //           required: true,
                      //           child: FormBuilderDropdown(
                      //             name: "satuanT",
                      //             initialValue: initValProgress(widget.id,
                      //                 widget.state.progressPesanan, "satuanT"),
                      //             // valueTransformer: (val) {
                      //             //   return valToInt(val);
                      //             // },
                      //             items: const [
                      //               DropdownMenuItem(
                      //                   child: Text("meter"), value: "m"),
                      //               DropdownMenuItem(
                      //                   child: Text("cm"), value: "cm"),
                      //               DropdownMenuItem(
                      //                   child: Text("mm"), value: "mm"),
                      //             ],
                      //             validator: FormBuilderValidators.required(
                      //                 context,
                      //                 errorText: requiredError()),
                      //             decoration: const InputDecoration(
                      //               errorMaxLines: 2,
                      //               border: OutlineInputBorder(),
                      //               isDense: true,
                      //               hintText: "Satuan",
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomFormField(
                              required: true,
                              child: FormBuilderTextField(
                                name: "durasi",
                                initialValue: initValProgress(
                                    widget.id,
                                    widget.state.progressPesanan,
                                    "waktupengerjaan"),
                                valueTransformer: (val) {
                                  return valToInt(val);
                                },
                                validator: FormBuilderValidators.required(
                                    errorText: requiredError()),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: "Durasi",
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: CustomFormField(
                              required: true,
                              child: FormBuilderDropdown(
                                name: "waktu",
                                initialValue: initValProgress(widget.id,
                                    widget.state.progressPesanan, "waktu"),
                                // valueTransformer: (val) {
                                //   return valToInt(val);
                                // },
                                items: const [
                                  DropdownMenuItem(
                                      value: "menit", child: Text("menit")),
                                  DropdownMenuItem(
                                      value: "jam", child: Text("jam")),
                                  DropdownMenuItem(
                                      value: "hari", child: Text("hari")),
                                ],
                                validator: FormBuilderValidators.required(
                                    errorText: requiredError()),
                                decoration: const InputDecoration(
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: "Waktu",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomFormField(
                        required: true,
                        child: FormBuilderDropdown(
                          name: "persentase",
                          initialValue: initValProgress(widget.id,
                              widget.state.progressPesanan, "persentase"),
                          valueTransformer: (val) {
                            return valToInt(val);
                          },
                          items: const [
                            DropdownMenuItem(value: "0", child: Text("0%")),
                            DropdownMenuItem(value: "25", child: Text("25%")),
                            DropdownMenuItem(value: "50", child: Text("50%")),
                            DropdownMenuItem(value: "75", child: Text("75%")),
                            DropdownMenuItem(value: "100", child: Text("100%")),
                          ],
                          validator: FormBuilderValidators.required(
                              errorText: requiredError()),
                          decoration: const InputDecoration(
                            errorMaxLines: 2,
                            border: OutlineInputBorder(),
                            isDense: true,
                            hintText: "Persentase",
                          ),
                        ),
                      ),
                      if (widget.id != null)
                        CustomFormField(
                          required: true,
                          child: FormBuilderDateTimePicker(
                            enabled: false,
                            name: "perkiraanSelesai",
                            format: DateFormat("dd-MM-yyyy"),
                            initialValue: initValDateProgressPerkiraanSelesai(
                              widget.id,
                              widget.state.progressPesanan,
                              widget.state.informasiPesanan["tanggalPesan"],
                            ),
                            //initValDateProgress(widget.id,
                            //  widget.state.progressPesanan, "perkiraanSelesai"),
                            inputType: InputType.date,
                            valueTransformer: (val) {
                              if (val != null) {
                                String date = dateToString(val);
                                return date;
                              }
                              return "";
                            },
                            validator: FormBuilderValidators.required(
                                errorText: requiredError()),
                            decoration: const InputDecoration(
                              errorMaxLines: 2,
                              border: OutlineInputBorder(),
                              isDense: true,
                              hintText: "Perkiraan Selesai",
                            ),
                          ),
                        ),
                      if (widget.id != null)
                        CustomFormField(
                          child: FormBuilderDateTimePicker(
                            format: DateFormat("dd-MM-yyyy"),
                            name: "tanggalSelesai",
                            initialValue: initValDateProgress(widget.id,
                                widget.state.progressPesanan, "tanggalSelesai"),
                            inputType: InputType.date,
                            valueTransformer: (val) {
                              if (val != null) {
                                String date = dateToString(val);
                                return date;
                              }
                              return "";
                            },
                            decoration: const InputDecoration(
                              errorMaxLines: 2,
                              border: OutlineInputBorder(),
                              isDense: true,
                              hintText: "Tanggal Selesai",
                            ),
                          ),
                        ),
                      CustomFormField(
                        child: FormBuilderTextField(
                          name: "catatan",
                          initialValue: initValProgress(widget.id,
                              widget.state.progressPesanan, "catatan"),
                          valueTransformer: (val) {
                            return val ?? "";
                          },
                          decoration: const InputDecoration(
                            errorMaxLines: 2,
                            border: OutlineInputBorder(),
                            isDense: true,
                            hintText: "Catatan",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: const Text("Kembali"),
        ),
        const SizedBox(width: 10),
        TextButton(onPressed: simpan, child: const Text("Simpan")),
      ],
    );
  }
}
