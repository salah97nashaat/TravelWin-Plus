import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
import 'package:travelwin/utils/theme.dart';

class MyTextFromField2 extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Function validator;
  final Widget suffixIcon;
  final String hintText;
  final String keyboardtypeText;
  const MyTextFromField2({
    required this.controller,
    required this.obscureText,
    required this.validator,
    required this.suffixIcon,
    required this.hintText,
    required this.keyboardtypeText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        children: [
          // Row(
          //   children: [
          //     Text(hintText,style: TextStyle(color: mainColor),)
          //   ],
          // ),
          // const SizedBox(height: 5,),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            cursorColor: Colors.black,
            keyboardType: keyboardtypeText == 'text'
                ? TextInputType.text
                : TextInputType.number,
            validator: (value) => validator(value),
            style: TextStyle(color: Colors.black, fontSize: 12.w),
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              filled: false,
              label: Text(
                hintText,
                style: TextStyle(color: mainColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: mainColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: mainColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: mainColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: mainColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
