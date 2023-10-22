import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String currencyValue = newValue.text.replaceAll(RegExp("[^0-9]"), "");
    double value = double.tryParse(currencyValue) ?? 0;

    final formatter = NumberFormat.currency(
      locale: "id",
      symbol: "Rp",
      decimalDigits: 0,
    );

    String newText = formatter.format(value);
    newText = newText.replaceAll("Rp", "");

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
