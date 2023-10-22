import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_form_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PasswordFormField extends StatefulWidget {
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String name;
  final String label;
  final bool readOnly;
  final bool? isDense;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;
  final InputBorder? border;
  final bool required;
  const PasswordFormField(
      {Key? key,
      this.initialValue,
      this.validator,
      this.controller,
      this.inputFormatters,
      this.isDense = false,
      this.contentPadding,
      required this.name,
      required this.label,
      this.border,
      this.readOnly = false,
      this.required = false})
      : super(key: key);

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  var obsecure = true;

  void showHide() {
    setState(() {
      obsecure = !obsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = FormBuilderTextField(
        name: widget.name,
        controller: widget.controller,
        initialValue: widget.initialValue,
        validator: widget.validator,
        readOnly: widget.readOnly,
        inputFormatters: widget.inputFormatters,
        obscureText: obsecure,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              obsecure ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: showHide,
          ),
          contentPadding: widget.contentPadding,
          border: const OutlineInputBorder(),
          isDense: widget.isDense,
          hintText: widget.label,
        ));
    return CustomFormField(child: child, required: widget.required);
  }
}
