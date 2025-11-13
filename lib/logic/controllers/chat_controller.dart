// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/ChatMessages.dart';
import 'package:travelwin/utils/my_string.dart';

class ChatController extends GetxController {
  @override
  onInit() {
    fetchChat();
    super.onInit();
  }
void fetchChat(){
  if (chatMessages.value.data == null || chatMessages.value.data!.isEmpty) {
    } else {
      sticker.value = 'assets/images/Hello-bro.svg';
      for (var i in chatMessages.value.data!) {
        if (i.type == 'text') {
          messages.add(i);       // triggers UI update
          messages.refresh(); // or update()
          // messages.insert(0, i); // for newest on top
          // messages.clear();      // works fine
        } else {
          print(i.url);
          sticker.value = i.url!;
        }
      }
    }
}
  RxList<Data> messages = <Data>[].obs;
  Rx<String> sticker = Rx('');
  void addMessage(Data message) {
    messages.add(message);
   // update();
  }

  void putSticker(mySticker) {
    sticker.value = mySticker;
    update();
  }
}
