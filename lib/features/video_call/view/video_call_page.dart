import 'dart:async';
import 'package:chat_app/features/video_call/components/bottom_controls_section.dart';
import 'package:chat_app/features/video_call/components/custom_app_bar.dart';
import 'package:chat_app/features/video_call/controller/video_call_controller.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

class VideoCallScreen extends StatefulWidget {
  VideoCallScreen({
    Key? key,
    required this.channelName,
  }) : super(key: key);

  final String channelName;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late AgoraController agoraController =
      Get.put<AgoraController>(AgoraController(channel: widget.channelName));

  @override
  void initState() {
    // Init State
    super.initState();
  }

  Future<void> _dispose() async {
    await agoraController.engine.leaveChannel();
    await agoraController.engine.release();
    agoraController.meetingTimer.cancel();
    Get.delete<AgoraController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(agoraController: agoraController),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
              top: 0.0,
            ),
            child: Obx(
              () {
                final totalRemoteusers = agoraController.remoteUsers.length;
                switch (totalRemoteusers) {
                  case 0:
                    // Only Current User
                    return _NoRemoteUserView(
                      agoraController: agoraController,
                    );

                  case 1:
                    // 1 Remote + 1 Current User
                    return _TwoUserView(
                      agoraController: agoraController,
                    );

                  case 2:
                    // 2 Remote + 1 Current User
                    return _ThreeUserView(agoraController: agoraController);

                  case 3:
                    // 3 Remote + 1 Current User
                    return _FourUserView(agoraController: agoraController);
                }
                return Container();
              },
            ),
          ),
          BottomControlSection(agoraController: agoraController),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }
}

class _FourUserView extends StatelessWidget {
  const _FourUserView({
    Key? key,
    required this.agoraController,
  }) : super(key: key);

  final AgoraController agoraController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: const Color(0xFF1A1E78)),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: agoraController.engine,
                        canvas: VideoCanvas(
                          uid: agoraController.remoteUsers[0],
                        ),
                        connection: RtcConnection(
                          channelId: agoraController.channelId,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: const Color(0xFF1A1E78)),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: agoraController.engine,
                        canvas: VideoCanvas(
                          uid: agoraController.remoteUsers[1],
                        ),
                        connection: RtcConnection(
                          channelId: agoraController.channelId,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: const Color(0xFF1A1E78)),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: agoraController.engine,
                        canvas: VideoCanvas(
                          uid: agoraController.remoteUsers[2],
                        ),
                        connection: RtcConnection(
                          channelId: agoraController.channelId,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: const Color(0xFF1A1E78)),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: agoraController.engine,
                        canvas: VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThreeUserView extends StatelessWidget {
  const _ThreeUserView({
    Key? key,
    required this.agoraController,
  }) : super(key: key);

  final AgoraController agoraController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: const Color(0xFF1A1E78)),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: agoraController.engine,
                        canvas: VideoCanvas(
                          uid: agoraController.remoteUsers[0],
                        ),
                        connection: RtcConnection(
                          channelId: agoraController.channelId,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: const Color(0xFF1A1E78)),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: agoraController.engine,
                        canvas: VideoCanvas(
                          uid: agoraController.remoteUsers[1],
                        ),
                        connection: RtcConnection(
                          channelId: agoraController.channelId,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: const Color(0xFF1A1E78)),
              borderRadius: BorderRadius.circular(26),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: agoraController.engine,
                  canvas: VideoCanvas(uid: 0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TwoUserView extends StatelessWidget {
  const _TwoUserView({
    Key? key,
    required this.agoraController,
  }) : super(key: key);

  final AgoraController agoraController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: const Color(0xFF1A1E78)),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: agoraController.engine,
                  canvas: VideoCanvas(uid: agoraController.remoteUsers[0]),
                  connection: RtcConnection(
                    channelId: agoraController.channelId,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: const Color(0xFF1A1E78)),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: agoraController.engine,
                  canvas: VideoCanvas(uid: 0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoRemoteUserView extends StatelessWidget {
  const _NoRemoteUserView({
    Key? key,
    required this.agoraController,
  }) : super(key: key);

  final AgoraController agoraController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: const Color(0xFF1A1E78)),
            borderRadius: BorderRadius.circular(26),
          ),
          child: agoraController.isJoined.value
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: agoraController.engine,
                      canvas: VideoCanvas(uid: 0),
                    ),
                  ),
                )
              : Center(
                  child: const CircularProgressIndicator(
                    color: const Color(0xFF1A1E78),
                  ),
                ),
        );
      },
    );
  }
}
