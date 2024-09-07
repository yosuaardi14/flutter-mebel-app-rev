import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';
import 'package:flutter_mebel_app_rev/app/data/services/currency_input_formatter.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/controllers/add_pesanan_controller_v2.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class FormInformasiPemesanan extends StatelessWidget {
  // final String? id;
  final AddPesananControllerV2 state;

  FormInformasiPemesanan({super.key, /*this.id,*/ required this.state});

  // final String status = "";
  final statusPembayaran = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    if (state.id != null) {
      statusPembayaran.value = state.detail.value?["info"]?["statusPembayaran"];
      state.newPembeli = false;
    }
    return Center(
      child: FormBuilder(
        key: AddPesananControllerV2.formKey[0],
        child: LoaderBooleanNotifierWidget(
          isLoading: state.isLoading,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomFormField(
                required: true,
                child: FormBuilderTextField(
                  name: "nama",
                  enabled: isAdmin(),
                  initialValue: initValCheck(
                      state.id, state.detail.value?["info"]?["nama"]),
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
                      state.id, state.detail.value?["info"]?["harga"]),
                  valueTransformer: (val) {
                    return currencyToInt(val);
                  },
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: requiredError()),
                  ]),
                  inputFormatters: [CurrencyInputFormatter()],
                  decoration: const InputDecoration(
                    errorMaxLines: 2,
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: "Harga",
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 12,
                      ),
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
                  initialValue: initValCheck(state.id,
                      state.detail.value?["info"]?["statusPembayaran"]),
                  items: const [
                    DropdownMenuItem(
                      value: "lunas",
                      child: Text("Lunas"),
                    ),
                    DropdownMenuItem(
                      value: "belumLunas",
                      child: Text("Belum Lunas"),
                    ),
                    DropdownMenuItem(
                      value: "dp",
                      child: Text("DP"),
                    ),
                  ],
                  onChanged: (val) {
                    statusPembayaran.value = val;
                  },
                  validator: FormBuilderValidators.required(
                    errorText: requiredError(),
                  ),
                  decoration: const InputDecoration(
                    errorMaxLines: 2,
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: "Status Pembayaran",
                  ),
                ),
              ),
              //if (status == "dp")
              ValueListenableBuilder(
                valueListenable: statusPembayaran,
                builder: (context, status, child) {
                  return CustomFormField(
                    required: status == "dp",
                    // ||
                    //     state.detail.value?["info"]?["statusPembayaran"] ==
                    //         "dp",
                    child: FormBuilderTextField(
                      name: "dpharga",
                      enabled: isAdmin(),
                      initialValue: initCurrencyCheck(
                          state.id, state.detail.value?["info"]?["dpharga"]),
                      valueTransformer: currencyToInt,
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        if (status == "dp" ||
                            state.detail.value?["info"]?["statusPembayaran"] ==
                                "dp")
                          FormBuilderValidators.required(
                              errorText: requiredError()),
                      ]),
                      readOnly: status != "dp" &&
                          state.detail.value?["info"]?["statusPembayaran"] !=
                              "dp",
                      inputFormatters: [CurrencyInputFormatter()],
                      decoration: const InputDecoration(
                        errorMaxLines: 2,
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: "DP",
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 12,
                          ),
                          child: Text('Rp'),
                        ),
                      ),
                    ),
                  );
                },
              ),
              CustomFormField(
                required: true,
                child: FormBuilderDateTimePicker(
                  name: "tanggalPesan",
                  enabled: isAdmin(),
                  format: DateFormat("dd-MM-yyyy"),
                  initialValue: initValDate(
                      state.id, state.detail.value?["info"]?["tanggalPesan"]),
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
                  initialValue: initValDate(state.id,
                      state.detail.value?["info"]?["perkiraanSelesai"]),
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
                  initialValue: initValDate(
                      state.id, state.detail.value?["info"]?["tanggalSelesai"]),
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
                  initialValue: initValCheck(
                      state.id, state.detail.value?["info"]?["deskripsi"]),
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
