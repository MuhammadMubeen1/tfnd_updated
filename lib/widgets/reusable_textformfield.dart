import 'package:flutter/material.dart';

import '../themes/color.dart';

class ReusableTextForm extends StatelessWidget {
  final String? Function(String?)? validator;
  final VoidCallback? Function(String?)? onChange;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool? obscureText;
  final bool? enabled;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Color? filledColor;
  final Widget? prefixIcon;
  final int maxLines;
  final TextCapitalization textCapitalization;

  const ReusableTextForm({
    Key? key,
    this.validator,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
    this.filledColor = AppColor.transparentColor,
    this.maxLines = 1,
    this.onChange,
    this.textCapitalization = TextCapitalization.sentences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textCapitalization: textCapitalization,
        onChanged: onChange,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText!,
        readOnly: readOnly!,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: filledColor,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          enabled: enabled!,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColor.hintColor),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 23, horizontal: 25),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: AppColor.borderFormColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: AppColor.borderFormColor, width: 1),
          ),
        ),
        // validations
        validator: validator);
  }
}
