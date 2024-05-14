import 'package:contacts/config/theme/custom_colors.dart';
import 'package:contacts/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class GreyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const GreyTextField({super.key, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30,
        left: 30,
        bottom: 20,
      ),
      child: TextField(
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 15,
            right: 15,
          ),
          isDense: true,
          isCollapsed: true,
          filled: true,
          fillColor: CustomColors.pageColor,
          hintText: hint,
          hintStyle: TextStyles.bodyLarge(color: CustomColors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
