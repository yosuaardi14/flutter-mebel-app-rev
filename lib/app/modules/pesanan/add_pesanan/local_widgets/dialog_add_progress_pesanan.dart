import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DialogAddProgressPesanan extends StatefulWidget {
  int? id;
  DialogAddProgressPesanan({Key? key, this.id}) : super(key: key);

  @override
  State<DialogAddProgressPesanan> createState() =>
      _DialogAddProgressPesananState();
}

class _DialogAddProgressPesananState extends State<DialogAddProgressPesanan> {
  final controller = Get.find<AddPesananController>();
  static final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> selectedPekerja = {};
  Map<String, dynamic> selectedExistingAktivitas = {};
  bool isNew = false;
  bool panjangVisible = false;
  bool jumlahVisible = false;
  String tahap = "all";

  void simpan() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> hasil = {};
      hasil["tahap"] = _formKey.currentState!.value["tahap"];
      if (isNew) {
        hasil["aktivitas"] = _formKey.currentState!.value["aktivitas"];
      } else {
        hasil["aktivitas"] = {
          "id": selectedExistingAktivitas["id"],
          "nama": selectedExistingAktivitas["aktivitas"],
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

      if (selectedExistingAktivitas.containsKey("panjang")) {
        hasil["panjang"] = _formKey.currentState!.value["panjang"];
      }
      if (selectedExistingAktivitas.containsKey("jumlah")) {
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
              //             selectedExistingAktivitas = {};
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
                              widget.id, controller.progressPesanan),
                          items: const [
                            DropdownMenuItem(
                                child: Text("Pengukuran"), value: "pengukuran"),
                            DropdownMenuItem(
                                child: Text("Pemotongan"), value: "pemotongan"),
                            DropdownMenuItem(
                                child: Text("Perakitan"), value: "perakitan"),
                            DropdownMenuItem(
                                child: Text("Pemasangan"), value: "pemasangan"),
                          ],
                          onChanged: (val) {
                            setState(() {
                              tahap = val;
                              _formKey.currentState!.fields["extaktivitas"]!
                                  .reset();
                              panjangVisible = false;
                              jumlahVisible = false;
                              // .didChange("");
                              if (!isNew) {
                                controller.getListAktivitas(val);
                                controller.update();
                              }
                            });
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
                      if (isNew)
                        CustomFormField(
                          required: true,
                          child: FormBuilderTextField(
                            name: "aktivitas",
                            initialValue: initValProgress(widget.id,
                                controller.progressPesanan, "aktivitas"),
                            valueTransformer: (val) {
                              return val ?? "";
                            },
                            validator: FormBuilderValidators.required(
                                errorText: requiredError()),
                            decoration: const InputDecoration(
                              errorMaxLines: 2,
                              border: OutlineInputBorder(),
                              isDense: true,
                              hintText: "Aktivitas",
                            ),
                          ),
                        ),
                      if (!isNew)
                        GetBuilder<AddPesananController>(
                          init: controller..getListAktivitas(tahap),
                          builder: (val) => CustomFormField(
                            required: true,
                            child: FormBuilderDropdown(
                              name: "extaktivitas",
                              enabled: isAdmin(),
                              initialValue: initValProgress(widget.id,
                                  controller.progressPesanan, "aktivitas"),
                              items: controller.listAktivitas!.isEmpty
                                  ? []
                                  : [
                                      ...controller.listAktivitas!.map((e) =>
                                          DropdownMenuItem(
                                              child: Text(e["aktivitas"]),
                                              value: e["id"]))
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
                                log(val.toString());
                                setState(() {
                                  panjangVisible = false;
                                });
                                setState(() {
                                  jumlahVisible = false;
                                });
                                setState(() {
                                  selectedExistingAktivitas =
                                      controller.listAktivitas!.firstWhere(
                                          (element) => value == element["id"]);
                                  log(selectedExistingAktivitas.toString());
                                });
                                if (selectedExistingAktivitas
                                    .containsKey("panjang")) {
                                  setState(() {
                                    panjangVisible = true;
                                  });
                                  setState(() {
                                    _formKey.currentState!.fields["panjang"]!
                                        .didChange(
                                            selectedExistingAktivitas["panjang"]
                                                .toString());
                                    _formKey.currentState!.fields["satuanP"]!
                                        .didChange("cm");
                                  });
                                }
                                if (selectedExistingAktivitas
                                    .containsKey("jumlah")) {
                                  setState(() {
                                    jumlahVisible = true;
                                  });
                                  setState(() {
                                    _formKey.currentState!.fields["jumlah"]!
                                        .didChange(
                                            selectedExistingAktivitas["jumlah"]
                                                .toString());
                                  });
                                }
                                setState(() {
                                  _formKey.currentState!.fields["durasi"]!
                                      .didChange(
                                          selectedExistingAktivitas["durasi"]
                                              .toString());
                                  _formKey.currentState!.fields["waktu"]!
                                      .didChange("menit");
                                });
                                // if (selectedExistingAktivitas
                                //     .containsKey("durasi")) {

                                // }
                              },
                              onSaved: (value) {
                                setState(() {
                                  selectedExistingAktivitas =
                                      controller.listAktivitas!.firstWhere(
                                          (element) => value == element["id"]);
                                });
                              },
                            ),
                          ),
                        ),
                      GetBuilder<AddPesananController>(
                        init: controller..getListPekerja(),
                        builder: (val) => CustomFormField(
                          required: true,
                          child: FormBuilderDropdown(
                            name: "pekerja",
                            enabled: isAdmin(),
                            initialValue: initValProgress(widget.id,
                                controller.progressPesanan, "pekerja"),
                            items: controller.listPekerja!.isEmpty
                                ? []
                                : [
                                    ...controller.listPekerja!.map((e) =>
                                        DropdownMenuItem(
                                            child: Text(e["nama"]),
                                            value: e["id"]))
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
                              log(val.toString());
                              setState(() {
                                selectedPekerja = controller.listPekerja!
                                    .firstWhere(
                                        (element) => value == element["id"]);
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                selectedPekerja = controller.listPekerja!
                                    .firstWhere(
                                        (element) => value == element["id"]);
                              });
                            },
                          ),
                        ),
                      ),
                      // if (panjangVisible)
                      Visibility(
                        visible: panjangVisible,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomFormField(
                                required: true,
                                child: FormBuilderTextField(
                                  name: "panjang",
                                  initialValue: initValProgress(widget.id,
                                      controller.progressPesanan, "panjang"),
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
                                            ((selectedExistingAktivitas[
                                                            "durasi"] *
                                                        panjang) /
                                                    selectedExistingAktivitas[
                                                        "panjang"])
                                                .round();
                                        _formKey.currentState!.fields["durasi"]!
                                            .didChange(durasi.toString());
                                      }
                                    } else {
                                      _formKey.currentState!.fields["durasi"]!
                                          .didChange("0");
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
                                  initialValue: initValProgress(widget.id,
                                      controller.progressPesanan, "satuanP"),
                                  items: const [
                                    DropdownMenuItem(
                                        child: Text("meter"), value: "m"),
                                    DropdownMenuItem(
                                        child: Text("cm"), value: "cm"),
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
                      ),
                      // if (jumlahVisible)
                      Visibility(
                        visible: jumlahVisible,
                        child: CustomFormField(
                          required: true,
                          child: FormBuilderTextField(
                            name: "jumlah",
                            initialValue: initValProgress(widget.id,
                                controller.progressPesanan, "jumlah"),
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
                                    int durasi = ((selectedExistingAktivitas[
                                                    "durasi"] *
                                                jumlah) /
                                            selectedExistingAktivitas["jumlah"])
                                        .round();
                                    _formKey.currentState!.fields["durasi"]!
                                        .didChange(durasi.toString());
                                  }
                                } else {
                                  _formKey.currentState!.fields["durasi"]!
                                      .didChange("0");
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      // CustomFormField(
                      //   required: true,
                      //   child: FormBuilderTextField(
                      //     name: "ukuran",
                      //     initialValue: initValProgress(
                      //         widget.id, controller.progressPesanan, "ukuran"),
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
                      //         // String ukuran = selectedExistingAktivitas["ukuran"];
                      //         // RegExp regex = RegExp(r'\d+');
                      //         // var listUkuran = ukuran.split(regex);
                      //         // log(listUkuran[0]);
                      //         _formKey.currentState!.fields["durasi"]!
                      //             .didChange("10");
                      //         // var satuanUkuran
                      //         // var tempWaktu = waktu;
                      //         // selectedExistingAktivitas
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
                      //                 controller.progressPesanan, "panjang"),
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
                      //                   int durasi = selectedExistingAktivitas[
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
                      //                 controller.progressPesanan, "satuanP"),
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
                      //             //       int durasi = selectedExistingAktivitas[
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
                      //                 controller.progressPesanan, "lebar"),
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
                      //                 controller.progressPesanan, "satuanL"),
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
                      //                 controller.progressPesanan, "tebal"),
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
                      //                 controller.progressPesanan, "satuanT"),
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
                                    controller.progressPesanan,
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
                                    controller.progressPesanan, "waktu"),
                                // valueTransformer: (val) {
                                //   return valToInt(val);
                                // },
                                items: const [
                                  DropdownMenuItem(
                                      child: Text("menit"), value: "menit"),
                                  DropdownMenuItem(
                                      child: Text("jam"), value: "jam"),
                                  DropdownMenuItem(
                                      child: Text("hari"), value: "hari"),
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
                              controller.progressPesanan, "persentase"),
                          valueTransformer: (val) {
                            return valToInt(val);
                          },
                          items: const [
                            DropdownMenuItem(child: Text("0%"), value: "0"),
                            DropdownMenuItem(child: Text("25%"), value: "25"),
                            DropdownMenuItem(child: Text("50%"), value: "50"),
                            DropdownMenuItem(child: Text("75%"), value: "75"),
                            DropdownMenuItem(child: Text("100%"), value: "100"),
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
                              controller.progressPesanan,
                              controller.informasiPesanan["tanggalPesan"],
                            ),
                            //initValDateProgress(widget.id,
                            //  controller.progressPesanan, "perkiraanSelesai"),
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
                                controller.progressPesanan, "tanggalSelesai"),
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
                          initialValue: initValProgress(
                              widget.id, controller.progressPesanan, "catatan"),
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
            child: const Text("Kembali")),
        const SizedBox(width: 10),
        TextButton(onPressed: simpan, child: const Text("Simpan")),
      ],
    );
  }
}
