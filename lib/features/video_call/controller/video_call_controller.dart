import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../utils/utils.dart';

class AgoraController {
  late RtcEngine engine;

  final _infoStrings = <String>[];

  // Meeeting Timer Helper
  late Timer meetingTimer;
  int meetingDuration = 0;
  RxString meetingDurationTxt = "00:00".obs;

  // Agora utitilty
  final muted = false.obs;
  final muteVideo = false.obs;
  final isJoined = false.obs;

  bool backCamera = false;
  bool isHost = true;

  final isSomeOneJoinedCall = false.obs;

  RxList<int> remoteUsers = <int>[].obs;
  int? remoteUidOne;

  // UI
  int networkQuality = 3;
  Color networkQualityBarColor = Colors.green;

  String channelId = '';

  String agoraAuthToken = '';

  final uid = Random().nextInt(19000);

  AgoraController({
    required final String channel,
  }) {
    channelId = channel;
    _generateAgoraAuthToken();
    init();
  }

  void onToggleMuteAudio() {
    muted.value = !muted.value;
    engine.muteLocalAudioStream(muted.value);
  }

  void onToggleMuteVideo() {
    muteVideo.value = !muteVideo.value;
    engine.muteLocalVideoStream(muteVideo.value);
  }

  void onSwitchCamera() {
    backCamera = !backCamera;
    engine.switchCamera();
  }

  Future<void> init() async {
    if (getAgoraAppId().isEmpty) {
      Get.snackbar("Error", "Agora APP_ID Is Not Valid");
      return;
    }
    engine = createAgoraRtcEngine();

    await engine.initialize(
      RtcEngineContext(
        appId: getAgoraAppId(),
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onConnectionStateChanged: (connection, state, reason) {
          dev.log("Connection State Changed ${state} $reason");
          isJoined.value = true;
        },
        onLeaveChannel: (connection, stats) {
          dev.log("local user ${connection.localUid} left");
          isJoined.value = false;
          remoteUsers.clear();
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          dev.log("local user ${connection.localUid} joined");

          isJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          dev.log("remote user $remoteUid joined");

          remoteUsers.add(remoteUid);

          remoteUidOne = remoteUid;
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          dev.log("remote user $remoteUid left channel");

          remoteUsers.remove(remoteUid);

          remoteUidOne = null;
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          dev.log(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
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
        onError: (err, msg) {
          dev.log('=========================');
          // ignore: sdk_version_since
          dev.log('${err.name}');
          dev.log('$msg');
          dev.log('=========================');
        },
      ),
    );

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: agoraAuthToken,
      channelId: channelId,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  void _generateAgoraAuthToken() {
    final role = RtcRole.publisher;

    final expirationInSeconds = 3600;
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expireTimestamp = currentTimestamp + expirationInSeconds;

    agoraAuthToken = RtcTokenBuilder.build(
      appId: getAgoraAppId(),
      appCertificate: getAgoraAppCertificate(),
      channelName: channelId,
      uid: uid.toString(),
      role: role,
      expireTimestamp: expireTimestamp,
    );
  }

  Future<void> initEngine() async {
    await engine.initialize(
      RtcEngineContext(
        appId: getAgoraAppId(),
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );
    // addEventHandlers();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    // await engine.setVideoEncoderConfiguration(
    //   const VideoEncoderConfiguration(
    //     dimensions: VideoDimensions(width: 640, height: 360),
    //     frameRate: 15,
    //     bitrate: 0,
    //   ),
    // );
    await engine.startPreview();
  }

  // void addEventHandlers() {
  //   engine.registerEventHandler(
  //     RtcEngineEventHandler(
  //       onError: (ErrorCodeType err, String msg) {
  //         dev.log("======================================");
  //         dev.log("             ERROR Joined              ");
  //         dev.log("======================================");
  //         dev.log('[onError] err: $err, msg: $msg');
  //       },
  //       onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
  //         dev.log(
  //           '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed',
  //         );

  //         isJoined.value = true;
  //       },
  //       onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
  //         dev.log("======================================");
  //         dev.log("             User Joined              ");
  //         dev.log("======================================");
  //         dev.log(
  //           '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed',
  //         );
  //         remoteUid.add(rUid);

  //         if (!meetingTimer.isActive) {
  //           startMeetingTimer();
  //         } else {
  //           startMeetingTimer();
  //         }
  //         isSomeOneJoinedCall.value = true;
  //       },
  //       onUserOffline:
  //           (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
  //         dev.log(
  //             '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');

  //         remoteUid.removeWhere((element) => element == rUid);
  //       },
  //       onLeaveChannel: (RtcConnection connection, RtcStats stats) {
  //         dev.log(
  //             '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');

  //         isJoined.value = false;
  //         remoteUid.clear();
  //       },
  //       onNetworkQuality: (connection, remoteUid, txQuality, rxQuality) {
  //         networkQuality = getNetworkQuality(txQuality.index);
  //         networkQualityBarColor = getNetworkQualityBarColor(txQuality.index);
  //       },
  //       onFirstRemoteVideoFrame:
  //           (connection, remoteUid, width, height, elapsed) {
  //         final info = 'firstRemoteVideo: $remoteUid ${width}x $height';
  //         _infoStrings.add(info);
  //       },
  //     ),
  //   );
  // }

  Future<void> joinChannel() async {
    await engine.joinChannel(
      token: agoraAuthToken,
      channelId: channelId,
      uid: uid,
      options: ChannelMediaOptions(),
    );
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
}
