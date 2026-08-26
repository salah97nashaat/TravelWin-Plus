import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:travelwin/logic/controllers/join_activity_controller.dart';
import 'package:travelwin/utils/theme.dart';

class JoinActivityPage extends StatelessWidget {
  final int activityId;
  JoinActivityPage({super.key, required this.activityId});

  final controller = Get.put(JoinActivityController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            SizedBox(height: 25.h),
            
            Text("Activity Participation".tr, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 5.h),
            Text("Fill your details to join the community".tr, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            
            const Divider(height: 40),

            _buildLabel("Full Name".tr + " *"),
            _buildTextField(controller.nameController, "Example: Ahmed Ali".tr),

            Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildLabel("Age".tr),
                  _buildTextField(controller.ageController, "22", isNumber: true),
                ])),
                SizedBox(width: 15.w),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildLabel("Phone".tr + " *"),
                  _buildTextField(controller.phoneController, "05xxxxxxx"),
                ])),
              ],
            ),

            _buildLabel("Email".tr),
            _buildTextField(controller.emailController, "name@email.com"),

            // _buildLabel("Name in the Book".tr),
            // Obx(() => Row(
            //   children: [
            //     _buildRadio("Real Name".tr, 'real'),
            //     _buildRadio("Alias Name".tr, 'alias'),
            //   ],
            // )),

            // _buildLabel("Cover Idea (Optional)".tr),
            // _buildTextField(controller.coverIdeaController, "Your suggestions for the book cover...", maxLines: 2),

            _buildLabel("Other Notes".tr),
            _buildTextField(controller.notesController, "Any additional info...".tr, maxLines: 2),

            _buildLabel("Attach file (PDF/Word) *".tr),
            _buildFilePicker(),

            SizedBox(height: 35.h),

            Obx(() => controller.isLoading.value 
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    minimumSize: Size(double.infinity, 55.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    shadowColor: mainColor.withOpacity(0.3),
                  ),
                  onPressed: () => controller.submitJoin(activityId),
                  child: Text("Submit".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                )),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  // --- UI Reusable Components ---

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h, top: 15.h), 
    child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: Colors.black87))
  );

  Widget _buildTextField(TextEditingController ctrl, String hint, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
    );
  }

  Widget _buildRadio(String label, String value) {
    return Expanded(
      child: RadioListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label, style: TextStyle(fontSize: 12.sp)),
        value: value,
        activeColor: mainColor,
        groupValue: controller.authorNameChoice.value,
        onChanged: (val) => controller.authorNameChoice.value = val.toString(),
      ),
    );
  }

  Widget _buildFilePicker() {
    return Obx(() => GestureDetector(
      onTap: () => controller.pickDocument(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: controller.fileName.value.isEmpty ? Colors.grey.shade300 : mainColor, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_upload_outlined, color: controller.fileName.value.isEmpty ? Colors.grey : mainColor),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                controller.fileName.value.isEmpty ? "Click to select file".tr : controller.fileName.value,
                style: TextStyle(color: controller.fileName.value.isEmpty ? Colors.grey : Colors.black87, fontSize: 13.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
