import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';

var mainColor1 = const Color(0xff225d84);
var mainColor2 = const Color(0xffcd2032);
var mainColor3 = const Color(0xff41af2a);

var colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xff225d84));
var primaryColor = colorScheme.inversePrimary;
var inversePrimaryColor = colorScheme.primary;

var colorScheme2 = ColorScheme.fromSeed(
    seedColor: mainColor3, dynamicSchemeVariant: DynamicSchemeVariant.fidelity);
var primaryColor2 = colorScheme2.primary;
var inversePrimaryColor2 = colorScheme2.inversePrimary;

var primaryTextStyle = const TextStyle(fontWeight: FontWeight.bold);
var secondaryTextStyle = TextStyle(color: colorScheme.secondary);

var tween1 = ColorTween(begin: Colors.red, end: Colors.orange);
var tween2 = ColorTween(begin: Colors.orange, end: Colors.green);

Color? getRatingColor(num rating) {
  if (rating == 5.0) return Colors.amberAccent;
  return rating < 2.5
      ? tween1.transform((rating / 2.5).toDouble())
      : tween2.transform((rating / 2.5 - 1).toDouble());
}

String intToFixedString(int value, int length) {
  int len1 = value.toString().length;
  if (len1 < length) {
    String pad = List.generate(length - len1, (index) => 0).join();
    return "$pad$value";
  }
  return "$value";
}

String formatDate(DateTime value) {
  var day = intToFixedString(value.day, 2);
  var month = intToFixedString(value.month, 2);
  var year = value.year;

  var hour = intToFixedString(value.toLocal().hour, 2);
  var mins = intToFixedString(value.toLocal().minute, 2);

  return "$year/$month/$day $hour:$mins";
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
