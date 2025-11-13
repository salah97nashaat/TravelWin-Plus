import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:video_player/video_player.dart';

class PlayVideoController extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  @override
  void onInit() {
    super.onInit();
    initializePlayer();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse("https://travelwin1.com/imges/win/win.mp4"));
    await Future.wait([videoPlayerController.initialize()]);
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        materialProgressColors: ChewieProgressColors(
            playedColor: Colors.red,
            handleColor: Colors.cyanAccent,
            backgroundColor: Colors.yellow,
            bufferedColor: Colors.lightGreen),
        placeholder: Container(
          color: Colors.greenAccent,
        ),
        autoInitialize: true);
    update();
  }
}
