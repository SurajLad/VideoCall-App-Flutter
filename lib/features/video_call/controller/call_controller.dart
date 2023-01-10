import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/log_sink.dart';
import '../../../utils/utils.dart';

class AgoraController extends GetxController {
  late RtcEngine engine;
  final isPreviewReady = false.obs;

  final _infoStrings = <String>[];

  // Meeeting Timer Helper
  late Timer meetingTimer;
  int meetingDuration = 0;
  var meetingDurationTxt = "00:00".obs;

  // Agora utitilty
  bool muted = false;
  bool muteVideo = false;
  bool backCamera = false;

  final isChannelJoined = false.obs;
  final isSomeOneJoinedCall = false.obs;

  Set<int> remoteUid = {};

  bool isUseFlutterTexture = false;
  bool isUseAndroidSurfaceView = false;
  ChannelProfileType channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;

  int networkQuality = 3;
  Color networkQualityBarColor = Colors.green;

  String channelId = '';

  AgoraController({required final String channel}) {
    channelId = channel;
  }

  @override
  void onInit() {
    _initEngine();
    engine = createAgoraRtcEngine();

    super.onInit();
  }

  void onToggleMuteAudio() {
    muted = !muted;
    engine.muteLocalAudioStream(muted);
  }

  void onToggleMuteVideo() {
    muteVideo = !muteVideo;
    engine.muteLocalVideoStream(muteVideo);
  }

  void onSwitchCamera() {
    backCamera = !backCamera;
    engine.switchCamera();
  }

  void startMeetingTimer() async {
    meetingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (meetingTimer) {
        int min = (meetingDuration ~/ 60);
        int sec = (meetingDuration % 60).toInt();

        meetingDurationTxt.value = min.toString() + ":" + sec.toString() + "";

        if (checkNoSignleDigit(min)) {
          meetingDurationTxt.value =
              "0" + min.toString() + ":" + sec.toString() + "";
        }
        if (checkNoSignleDigit(sec)) {
          if (checkNoSignleDigit(min)) {
            meetingDurationTxt.value =
                "0" + min.toString() + ":0" + sec.toString() + "";
          } else {
            meetingDurationTxt.value =
                min.toString() + ":0" + sec.toString() + "";
          }
        }
        meetingDuration = meetingDuration + 1;
      },
    );
  }

  Future<void> _initEngine() async {
    if (getAgoraAppId().isEmpty) {
      Get.snackbar("", "Agora APP_ID Is Not Valid");
      return;
    }

    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: getAgoraAppId(),
    ));

    _addAgoraEventHandlers();

    await engine.enableVideo();
    await engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );

    await engine.startPreview();

    isPreviewReady.value = true;
    _joinAgoraChannel();
  }

  Future<void> _joinAgoraChannel() async {
    await engine.joinChannel(
      token: '32776543787e488f8ff1fe985dc478b3',
      channelId: channelId,
      uid: 0,
      options: ChannelMediaOptions(
        channelProfile: channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  void _addAgoraEventHandlers() {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          logSink.log('[onError] err: $err, msg: $msg');
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          logSink.log(
              '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');

          isChannelJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
          print("======================================");
          print("             User Joined              ");
          print("======================================");
          logSink.log(
            '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed',
          );
          remoteUid.add(rUid);

          if (!meetingTimer.isActive) {
            startMeetingTimer();
          } else {
            startMeetingTimer();
          }
          isSomeOneJoinedCall.value = true;
        },
        onUserOffline:
            (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
          logSink.log(
              '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');

          remoteUid.removeWhere((element) => element == rUid);
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          logSink.log(
              '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');

          isChannelJoined.value = false;
          remoteUid.clear();
        },
        onNetworkQuality: (connection, remoteUid, txQuality, rxQuality) {
          networkQuality = getNetworkQuality(txQuality.index);
          networkQualityBarColor = getNetworkQualityBarColor(txQuality.index);
        },
        onFirstRemoteVideoFrame:
            (connection, remoteUid, width, height, elapsed) {
          final info = 'firstRemoteVideo: $remoteUid ${width}x $height';
          _infoStrings.add(info);
        },
      ),
    );
  }

  int getNetworkQuality(int txQuality) {
    switch (txQuality) {
      case 0:
        return 2;

      case 1:
        return 4;

      case 2:
        return 3;

      case 3:
        return 2;

      case 4:
        return 1;

      case 4:
        return 0;
    }
    return 0;
  }

  Color getNetworkQualityBarColor(int txQuality) {
    switch (txQuality) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.redAccent;
      case 4:
        return Colors.red;
      case 4:
        return Colors.red;
    }
    return Colors.yellow;
  }
}
