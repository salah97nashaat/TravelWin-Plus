import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart'; // Import is required
import 'package:http/http.dart' as http;
import 'package:travelwin/utils/my_string.dart';

class JoinActivityController extends GetxController {
  var isLoading = false.obs;

  // All Text Controllers
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final coverIdeaController = TextEditingController();
  final notesController = TextEditingController();

  var authorNameChoice = 'real'.obs; // 'real' or 'alias'
  var fileName = "".obs;
  File? selectedFile;

  void pickDocument() async {
    try {
      final PlatformFile? file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (file != null && file.path != null) {
        selectedFile = File(file.path!);
        fileName.value = file.name;
      }
    } catch (e) {
      Get.snackbar("Error".tr, "Could not select file".tr);
    }
  }

  Future<void> submitJoin(int activityId) async {
    // Basic Validation
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedFile == null) {
      Get.snackbar("Error".tr, "Please fill required fields and attach file".tr,
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading(true);

      var uri = Uri.parse('$baseUrl/activities/join');
      var request = http.MultipartRequest('POST', uri);

      // ADDING ALL REQUESTED FIELDS
      request.fields.addAll({
        'activity_id': activityId.toString(),
        'name': nameController.text.trim(),
        'age': ageController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'author_name_choice': authorNameChoice.value,
        'cover_idea': coverIdeaController.text.trim(),
        'lang': Get.locale?.languageCode ?? 'ar',
        'notes': notesController.text.trim(),
      });

      // Attach File
      request.files.add(
        await http.MultipartFile.fromPath('file', selectedFile!.path),
      );

      // To prevent 413, manually set the length if needed,
      // but usually, request.send() handles this.
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Get.back(); // Close UI
        Get.snackbar("Success".tr, "Sent to Telegram successfully".tr,
            backgroundColor: Colors.green, colorText: Colors.white);
        _clearForm();
      } else {
        print("Server Error: ${response.body}");
        Get.snackbar(
            "Error".tr, "${"Server Error".tr}: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error".tr, "Check your connection".tr);
    } finally {
      isLoading(false);
    }
  }

  void _clearForm() {
    nameController.clear();
    ageController.clear();
    phoneController.clear();
    emailController.clear();
    coverIdeaController.clear();
    notesController.clear();
    fileName.value = "";
    selectedFile = null;
  }
}
