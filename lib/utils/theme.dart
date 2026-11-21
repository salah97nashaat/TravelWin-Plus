import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color mainColor = Color(0xff215B82);
const Color mainColor2 = Color(0xff046BA5);
const Color mainColor3 = Color(0xF2F2F4FF);
const Color goldAccent = Color(0xFFD4AF37);
const Color goldAccentLight = Color(0xFFF6E05E);
const Color darkGreyClr = Color(0xFF000000);
const Color darkGreyClr2 = Color(0xFF444444);
const Color gray = Color(0xffc2c2bd);
const Color darkGreyClr3 = Color.fromRGBO(214, 215, 200, 0.3);

const Color pinkClr = Color(0xFFff4667);
const Color kCOlor1 = Color(0xff685959);
const Color kCOlor2 = Color(0xffADA79B);
const Color kCOlor3 = Color(0xffA5947F);
const Color kCOlor4 = Color(0xff738B71);

const Color kCOlor5 = Color(0xff6D454D);

const Color litmain = Color(0xE5F2F4FF);

const Color darkSettings = Color(0xff6132e4);
const Color accountSettings = Color(0xff73bc65);
const Color shareSettings = Color(0xff6D454D);
const Color privacySettings = Color(0xE1901EB0);
const Color aboutSettings = Color(0xE12DB01E);
const Color logOutSettings = Color(0xff5f95ef);
const Color notiSettings = Color(0xffdf5862);
const Color languageSettings = Color(0xffCB256C);
const Color deleteAccountSettings = Colors.red;

class ThemesApp {
  static final light = ThemeData(
    primaryColor: mainColor,
    // backgroundColor: Colors.white,
    brightness: Brightness.light,
    //  buttonColor: Colors.yellow,

    buttonTheme: ButtonThemeData(
      buttonColor: mainColor,
    ),
    textTheme: GoogleFonts.readexProTextTheme(),
    colorScheme: ColorScheme(
      // background: Colors.white,
      // surface: Colors.white,
      brightness: Brightness.light,
      error: Colors.red,
      // onBackground: Colors.black,
      // onSurface: Colors.black,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      primary: mainColor,
      secondary: mainColor,
      surface: Colors.white,
    ),
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    // backgroundColor: darkGreyClr2,
    brightness: Brightness.dark,

    colorScheme: ColorScheme(
      // background: darkGreyClr2,
      brightness: Brightness.dark,
      error: Colors.red,
      // onBackground: Colors.white,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      primary: Colors.yellow,
      secondary: Colors.yellow,
      surface: darkGreyClr2,
    ),
  );
}
