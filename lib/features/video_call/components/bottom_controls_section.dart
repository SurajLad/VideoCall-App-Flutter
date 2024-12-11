import 'package:chat_app/features/video_call/controller/video_call_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomControlSection extends StatelessWidget {
  const BottomControlSection({
    Key? key,
    required this.agoraController,
  }) : super(key: key);

  final AgoraController agoraController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        padding: const EdgeInsets.only(top: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () {
                return InkWell(
                  onTap: () {
                    agoraController.onToggleMuteAudio();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: agoraController.muted.value
                          ? Colors.white12
                          : Colors.blueAccent,
                    ),
                    child: Icon(
                      agoraController.muted.value ? Icons.mic : Icons.mic_off,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            Obx(
              () {
                return InkWell(
                  onTap: () {
                    agoraController.onSwitchCamera();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: agoraController.muteVideo.value
                          ? Colors.white12
                          : Colors.blueAccent,
                    ),
                    child: Icon(
                      agoraController.muteVideo.value
                          ? Icons.camera_front
                          : Icons.photo_camera_back,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white12,
              ),
              child: Icon(
                Icons.video_call_sharp,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
