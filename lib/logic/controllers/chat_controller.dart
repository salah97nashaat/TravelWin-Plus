// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/ChatMessages.dart';
import 'package:travelwin/utils/my_string.dart';

class ChatController extends GetxController {
  RxList<Data> messages = <Data>[].obs;
  Rx<String> sticker = Rx('');

  @override
  void onInit() {
    loadMessages();
    super.onInit();
  }

  void loadMessages() {
    messages.clear();
    if (chatMessages.value.data != null && chatMessages.value.data!.isNotEmpty) {
      for (var i in chatMessages.value.data!) {
        messages.add(i);
      }
    }
  }

  void addMessage(Data message) {
    messages.add(message);
  }

  void putSticker(mySticker) {
    sticker.value = mySticker;
    update();
  }
}
