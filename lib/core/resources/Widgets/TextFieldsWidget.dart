import 'package:fitness/core/resources/AppColors/AppColors.dart';
import 'package:fitness/core/resources/AppStyles/AppStyles.dart';
import 'package:flutter/material.dart';

class TextFieldsWidget extends StatelessWidget {
  String hint;
  Widget suffixIcon;
  TextEditingController controller;
  TextFieldsWidget({
    super.key,
    required this.hint,
    required this.controller,
    required this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.myBlack,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        label: Text(hint, style: AppStyles.hintText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.myBlack, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.myGray1, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.myBlack, width: 2),
        ),
        fillColor: AppColors.myWhite,
        filled: true,
      ),
    );
  }
}
