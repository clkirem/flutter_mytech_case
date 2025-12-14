import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final Color inputFillColor;
  final Color hintTextColor;
  final TextEditingController? controller;
  final bool isPassword;
  final bool hasError;
  final Color errorColor;
  final TextInputType keyboardType;

  final Widget? suffixIcon;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.inputFillColor,
    required this.hintTextColor,
    this.controller,
    this.isPassword = false,
    this.hasError = false,
    this.errorColor = Colors.red,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultBorderColor = hintTextColor.withOpacity(0.5);
    final Color primaryColor = Colors.blue;

    final OutlineInputBorder defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: defaultBorderColor, width: 1.0),
    );

    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: errorColor, width: 1.5),
    );

    final OutlineInputBorder focusedStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),

      borderSide: BorderSide(color: hasError ? errorColor : primaryColor, width: hasError ? 2.0 : 2.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,

          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: hintTextColor),
            filled: true,
            fillColor: inputFillColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),

            suffixIcon: suffixIcon,

            enabledBorder: hasError ? errorBorder : defaultBorder,

            focusedBorder: focusedStyle,

            border: hasError ? errorBorder : defaultBorder,

            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
          ),
        ),
      ],
    );
  }
}
