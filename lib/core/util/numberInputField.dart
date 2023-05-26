import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendoorr/core/util/inputBorder.dart';

class NumberInputField extends StatelessWidget {
  const NumberInputField({
    Key key,
    this.controller,
    this.validator,
    this.hintText,
    this.prefix,
    this.canBeEmpty = false,
    this.isEnabled = true,
    this.onChanged,
    this.isAutoValidate = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String Function(String) validator;
  final void Function(String) onChanged;
  final String hintText;
  final bool canBeEmpty;
  final bool isEnabled;
  final String prefix;
  final bool isAutoValidate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (String value) {
        String returnOfValidator = null;
        if (validator != null) {
          returnOfValidator = validator(value);
          if (returnOfValidator != null) return returnOfValidator;
        }
        if (canBeEmpty && value == '') return null;
        if (double.tryParse(value) == null) return "Error";
        return null;
      },
      autovalidateMode: isAutoValidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[0-9,.]', caseSensitive: false),
          replacementString: '',
        ),
      ],
      onChanged: onChanged,
      style: TextStyle(fontFamily: "Montserrat"),
      controller: controller,
      decoration: inputDecoration(
        isenabled: isEnabled,
        hintText: hintText,
        prefix: prefix == null ? null : Text(prefix),
      ),
      enabled: isEnabled,
    );
  }
}
