// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerUtil extends ChangeNotifier {
  VideoPlayerUtil({required this.listOfVideos});
  final List<dynamic> listOfVideos;
  late List<VideoPlayerController> controllers;
  bool _isLoading = true;
  bool get isLoading => _isLoading;



  Future<void> initializeControllers(Function setState) async {
    final int controllerCount = listOfVideos.length;
    controllers = List.generate(
      controllerCount,
      (index) =>
          VideoPlayerController.networkUrl(Uri.parse(listOfVideos[index])),
    );
    await Future.wait(controllers.map((controller) => controller.initialize()));
    _isLoading = false;
    setState();
  }

  void disposeControllers() {
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  void handlePageChanged(int value) {
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].pause();
    }
  }

  void onPlayButtonClicked(int index, bool isVideoPlaying, Function changeValueState) {
    if (isVideoPlaying) {
      controllers[index].pause();
    } else {
      controllers[index].play();
      controllers[index].setLooping(true);
    }

    changeValueState();
  }
}
