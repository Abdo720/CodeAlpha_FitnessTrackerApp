import 'package:fitness/core/resources/AppColors/AppColors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle appBarText = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static TextStyle chipLabelTextUnSelected = TextStyle(
    color: AppColors.myBlack,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle chipLabelTextSelected = TextStyle(
    color: AppColors.myWhite,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle nonFound = TextStyle(
    color: AppColors.myBlack,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headers = TextStyle(
    color: AppColors.myBlack,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle smallHeaders = TextStyle(
    color: AppColors.myBlack,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle hintText = TextStyle(
    color: AppColors.myGray1,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
