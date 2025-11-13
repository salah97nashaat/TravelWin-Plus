import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
import 'package:travelwin/utils/theme.dart';

class AuthTextFromField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Function validator;
  final Function()? onTap;
  final Widget suffixIcon;
  final String hintText;
  final String keyboardtypeText;
  const AuthTextFromField({
    required this.controller,
    required this.obscureText,
    this.onTap,
    required this.validator,
    required this.suffixIcon,
    required this.hintText,
    required this.keyboardtypeText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: TextFormField(
        onTap: onTap != null ? onTap : () {},
        readOnly: onTap != null,
        controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.black,
        keyboardType: keyboardtypeText == 'text'
            ? TextInputType.text
            : TextInputType.number,
        validator: (value) => validator(value),
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          suffixIcon: suffixIcon,
          labelText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black45,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          filled: false,
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: mainColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: mainColor),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: mainColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: mainColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
