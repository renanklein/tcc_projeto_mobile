import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FunctionTextFormField extends StatelessWidget {
  final controller,
      label,
      hint,
      errorText,
      onChangedFunction,
      validatorFunction,
      isNumber;

  FunctionTextFormField({
    @required this.controller,
    @required this.label,
    @required this.hint,
    @required this.errorText,
    @required this.onChangedFunction,
    @required this.validatorFunction,
    @required this.isNumber,
  });

  @override
  Widget build(BuildContext context) {
    if (isNumber) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            labelText: label,
            hintText: hint,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
          ],
          validator: validatorFunction,
          onChanged: onChangedFunction,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            labelText: label,
            hintText: hint,
          ),
          validator: validatorFunction,
          onChanged: onChangedFunction,
        ),
      );
    }
  }
}
