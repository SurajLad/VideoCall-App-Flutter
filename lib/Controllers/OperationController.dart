import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

class OperationController extends GetxController {
  bool muted = false;
  bool muteVideo = false;

  void onToggleMuteAudio() {
    muted = !muted;

    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void onToggleMuteVideo() {
    muteVideo = !muteVideo;
    AgoraRtcEngine.muteLocalVideoStream(muteVideo);
  }
}
