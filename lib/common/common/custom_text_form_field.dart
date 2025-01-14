import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;

  const CustomTextFormField({super.key, this.hintText, this.errorText});

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      // border side 테두리
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );
    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8.0),
        hintText: hintText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        errorText: errorText,
        // true > 배경색 있음, false > 배경색 없음
        filled: true,
        fillColor: INPUT_BG_COLOR,
        border: baseBorder,
      ),
    );
  }
}
