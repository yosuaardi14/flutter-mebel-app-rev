import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/data/services/currency_input_formatter.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormInformasiPemesanan extends StatefulWidget {
  final String? id;

  FormInformasiPemesanan({Key? key, this.id}) : super(key: key);

  @override
  State<FormInformasiPemesanan> createState() => _FormInformasiPemesananState();
}

class _FormInformasiPemesananState extends State<FormInformasiPemesanan> {
  final controller = Get.find<AddPesananController>();

  String status = "";

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controller.newPembeli = false;
    }
    return Center(
      child: FormBuilder(
        key: AddPesananController.formKey[0],
        child: GetBuilder<AddPesananController>(
          init: controller,
          builder: (AddPesananController val) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: val.isLoading.value
                ? [
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  ]
                : [
                    CustomFormField(
                      required: true,
                      child: FormBuilderTextField(
                        name: "nama",
                        enabled: isAdmin(),
                        initialValue: initValCheck(
                            widget.id, controller.detail!["info"]?["nama"]),
                        validator: FormBuilderValidators.required(
                            errorText: requiredError()),
                        decoration: const InputDecoration(
                          errorMaxLines: 2,
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "Nama Pesanan",
                        ),
                      ),
                    ),
                    CustomFormField(
                      required: true,
                      child: FormBuilderTextField(
                        name: "harga",
                        enabled: isAdmin(),
                        initialValue: initCurrencyCheck(
                            widget.id, controller.detail!["info"]?["harga"]),
                        valueTransformer: (val) {
                          return currencyToInt(val);
                        },
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: requiredError()),
                        ]),
                        inputFormatters: [CurrencyInputFormatter()],
                        decoration: const InputDecoration(
                          errorMaxLines: 2,
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "Harga",
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 12),
                            child: Text('Rp'),
                          ),
                        ),
                      ),
                    ),
                    CustomFormField(
                      required: true,
                      child: FormBuilderDropdown(
                        name: "statusPembayaran",
                        enabled: isAdmin(),
                        initialValue: initValCheck(widget.id,
                            controller.detail!["info"]?["statusPembayaran"]),
                        items: const [
                          DropdownMenuItem(
                              child: Text("Lunas"), value: "lunas"),
                          DropdownMenuItem(
                              child: Text("Belum Lunas"), value: "belumLunas"),
                          DropdownMenuItem(child: Text("DP"), value: "dp"),
                        ],
                        onChanged: (val) {
                          setState(() {
                            status = val;
                          });
                        },
                        validator: FormBuilderValidators.required(
                            errorText: requiredError()),
                        decoration: const InputDecoration(
                          errorMaxLines: 2,
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "Status Pembayaran",
                        ),
                      ),
                    ),
                    //if (status == "dp")
                    CustomFormField(
                      required: status == "dp" ||
                          controller.detail!["info"]?["statusPembayaran"] ==
                              "dp",
                      child: FormBuilderTextField(
                        name: "dpharga",
                        enabled: isAdmin(),
                        initialValue: initCurrencyCheck(
                            widget.id, controller.detail!["info"]?["dpharga"]),
                        valueTransformer: (val) {
                          return currencyToInt(val);
                        },
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          if (status == "dp" ||
                              controller.detail!["info"]?["statusPembayaran"] ==
                                  "dp")
                            FormBuilderValidators.required(
                                errorText: requiredError()),
                        ]),
                        readOnly: status != "dp" &&
                            controller.detail!["info"]?["statusPembayaran"] !=
                                "dp",
                        inputFormatters: [CurrencyInputFormatter()],
                        decoration: const InputDecoration(
                          errorMaxLines: 2,
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "DP",
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 12),
                            child: Text('Rp'),
                          ),
                        ),
                      ),
                    ),
                    CustomFormField(
                      required: true,
                      child: FormBuilderDateTimePicker(
                        name: "tanggalPesan",
                        enabled: isAdmin(),
                        format: DateFormat("dd-MM-yyyy"),
                        initialValue: initValDate(widget.id,
                            controller.detail!["info"]?["tanggalPesan"]),
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
                          hintText: "Tanggal Pesan",
                        ),
                      ),
                    ),
                    CustomFormField(
                      required: true,
                      child: FormBuilderDateTimePicker(
                        name: "perkiraanSelesai",
                        enabled: isAdmin(),
                        format: DateFormat("dd-MM-yyyy"),
                        initialValue: initValDate(widget.id,
                            controller.detail!["info"]?["perkiraanSelesai"]),
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
                    CustomFormField(
                      child: FormBuilderDateTimePicker(
                        name: "tanggalSelesai",
                        enabled: isAdmin(),
                        format: DateFormat("dd-MM-yyyy"),
                        initialValue: initValDate(widget.id,
                            controller.detail!["info"]?["tanggalSelesai"]),
                        valueTransformer: (val) {
                          if (val != null) {
                            String date = dateToString(val);
                            return date;
                          }
                          return "";
                        },
                        inputType: InputType.date,
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
                        name: "deskripsi",
                        enabled: isAdmin(),
                        initialValue: initValCheck(widget.id,
                            controller.detail!["info"]?["deskripsi"]),
                        valueTransformer: (val) {
                          return val ?? "";
                        },
                        maxLines: 3,
                        decoration: const InputDecoration(
                          errorMaxLines: 2,
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "Deskripsi",
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
