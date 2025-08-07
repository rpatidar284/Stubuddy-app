import 'package:flutter/material.dart';
import 'package:stu_buddy/utils/theme/customTheme/textTheme.dart';
import 'package:stu_buddy/utils/theme/customTheme/bottomSheetTheme.dart';
import 'package:stu_buddy/utils/theme/customTheme/checkBoxTheme.dart';
import 'package:stu_buddy/utils/theme/customTheme/chipTheme.dart';
import 'package:stu_buddy/utils/theme/customTheme/elevatedButton.dart';
import 'package:stu_buddy/utils/theme/customTheme/outlinedButtonTheme.dart';
import 'package:stu_buddy/utils/theme/customTheme/appbarTheme.dart';
import 'package:stu_buddy/utils/theme/customTheme/textFieldTheme.dart';

class SAppTheme {
  SAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: StextTheme.lightTheme,
    elevatedButtonTheme: SElevatedButtonTheme.lightElevatedButton,
    chipTheme: SChipTheme.lightChipTheme,
    appBarTheme: SAppBarTheme.lightAppBarTheme,
    checkboxTheme: SCkBoxTheme.lightCkBoxTheme,
    bottomSheetTheme: SBottomSheetTheme.lightBottomSheetTheme,
    outlinedButtonTheme: SOutlinedButtonTheme.lightOutlinedButton,
    inputDecorationTheme: STextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData datkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: StextTheme.lightTheme,
    elevatedButtonTheme: SElevatedButtonTheme.lightElevatedButton,
    chipTheme: SChipTheme.lightChipTheme,
    appBarTheme: SAppBarTheme.lightAppBarTheme,
    checkboxTheme: SCkBoxTheme.lightCkBoxTheme,
    bottomSheetTheme: SBottomSheetTheme.lightBottomSheetTheme,
    outlinedButtonTheme: SOutlinedButtonTheme.lightOutlinedButton,
    inputDecorationTheme: STextFormFieldTheme.lightInputDecorationTheme,
  );
}
