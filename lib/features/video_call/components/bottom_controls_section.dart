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
        padding: const EdgeInsets.only(bottom: 24),
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
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 193, 195, 255),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Icon(
                      agoraController.isMuted.value
                          ? Icons.mic_sharp
                          : Icons.mic_off_sharp,
                      color: Colors.black87,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 20),
            Obx(
              () {
                return InkWell(
                  onTap: () {
                    agoraController.onSwitchCamera();
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 193, 195, 255),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Icon(
                      agoraController.isBackCamera.value
                          ? Icons.camera_front
                          : Icons.camera_rear,
                      color: Colors.black87,
                      size: 26,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 20),
            Obx(
              () {
                return InkWell(
                  onTap: () {
                    agoraController.onToggleMuteVideo();
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 193, 195, 255),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Icon(
                      agoraController.isVideoMuted.value
                          ? Icons.videocam_off
                          : Icons.videocam_sharp,
                      color: Colors.black87,
                      size: 26,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 252, 44, 29),
                ),
                child: Icon(
                  Icons.call_end,
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
