import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData preIcon;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final String hintText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.preIcon,
    required this.labelText,
    required this.keyboardType,
    required this.validator,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        prefixIcon: Icon(preIcon),
        labelText: labelText,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      controller: controller,
      onSaved: (value) => controller.text = value!,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
