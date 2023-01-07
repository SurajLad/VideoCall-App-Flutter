import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chat_app/components/utils.dart';
import 'package:get/get.dart';

class AgoraController extends GetxController {
  late RtcEngine engine;

  // Meeeting Timer Helper
  late Timer meetingTimer;
  int meetingDuration = 0;
  var meetingDurationTxt = "00:00".obs;

  // Agora utitilty
  bool muted = false;
  bool muteVideo = false;
  bool backCamera = false;

  @override
  void onInit() {
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
}
