// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Rx<XFile?> image = XFile('').obs;
launchWhatsapp(String message, number) async {
  var url = "https://wa.me/${number}?text=$message";
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

String googlePass =
    '\$2y\$10\$uEJxfnr6GOgLc6h1Cwd/Y.PbY5/OvjZTSy.ztR3IRE.slv4H5ICaS';
