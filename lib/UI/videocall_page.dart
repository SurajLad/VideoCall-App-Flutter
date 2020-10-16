import 'dart:async';
import 'package:chat_app/Controllers/agora_controller.dart';
import 'package:chat_app/Helpers/utils.dart';
import 'package:chat_app/UI/home_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelName;

  VideoCallScreen({this.channelName});
  @override
  VideoCallScreenState createState() => VideoCallScreenState();
}

class VideoCallScreenState extends State<VideoCallScreen> {
  static final _users = <int>[];
  final _infoStrings = <String>[];

  // UserJoined Bool
  bool isSomeOneJoinedCall = false;
  final AgoraController agoraController = Get.put(AgoraController());

  int networkQuality = 3;
  Color networkQualityBarColor = Colors.green;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    print("\n============ ON DISPOSE ===============\n");
    super.dispose();

    if (agoraController.meetingTimer != null) {
      agoraController.meetingTimer.cancel();
    }

    // clear users
    _users.clear();

    // destroy Agora sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
  }

  @override
  void initState() {
    // initialize agora sdk
    initAgoraRTC();

    super.initState();
  }

  Future<void> initAgoraRTC() async {
    if (getAgoraAppId().isEmpty) {
      Get.snackbar("", "Agora APP_ID Is Not Valid");
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);

    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":640,\"height\":360,\"frameRate\":30,\"bitRate\":800}}''');
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(getAgoraAppId());
    await AgoraRtcEngine.enableVideo();
  }

  /// agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      print("======== AGORA ERROR  : ======= " + code.toString());
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };
    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      print("======================================");
      print("             User Joined              ");
      print("======================================");
      if (agoraController.meetingTimer != null) {
        if (!agoraController.meetingTimer.isActive) {
          agoraController.startMeetingTimer();
        }
      } else {
        agoraController.startMeetingTimer();
      }

      isSomeOneJoinedCall = true;

      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };
    AgoraRtcEngine.onNetworkQuality = (int uid, int txQuality, int rxQuality) {
      setState(() {
        networkQuality = getNetworkQuality(txQuality);
        networkQualityBarColor = getNetworkQualityBarColor(txQuality);
      });
    };
    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
    AgoraRtcEngine.onUserMuteAudio = (int uid, bool muted) {};
  }

  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget buildJoinUserUI() {
    final views = _getRenderViews();

    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return new Container(
            width: Get.width,
            height: Get.height,
            child: new Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      _expandedVideoRow([views[1]]),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 8,
                            color: Colors.white38,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.fromLTRB(15, 40, 10, 15),
                        width: 110,
                        height: 140,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _expandedVideoRow([views[0]]),
                          ],
                        )))
              ],
            ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  void onCallEnd(BuildContext context) async {
    if (agoraController.meetingTimer != null) {
      if (agoraController.meetingTimer.isActive) {
        agoraController.meetingTimer.cancel();
      }
    }

    if (isSomeOneJoinedCall) {
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "No one has not joined this call yet,\nDo You want to close this room?"),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return;
      },
      child: Scaffold(
        body: buildNormalVideoUI(),
        bottomNavigationBar: GetBuilder<AgoraController>(builder: (_) {
          return ConvexAppBar(
            style: TabStyle.fixedCircle,
            backgroundColor: const Color(0xFF1A1E78),
            color: Colors.white,
            items: [
              TabItem(
                icon: _.muted ? Icons.mic_off_outlined : Icons.mic_outlined,
              ),
              TabItem(
                icon: Icons.call_end_rounded,
              ),
              TabItem(
                icon: _.muteVideo
                    ? Icons.videocam_off_outlined
                    : Icons.videocam_outlined,
              ),
            ],
            initialActiveIndex: 2, //optional, default as 0
            onTap: (int i) {
              switch (i) {
                case 0:
                  _.onToggleMuteAudio();
                  break;
                case 1:
                  onCallEnd(context);
                  break;
                case 2:
                  _.onToggleMuteVideo();
                  break;
              }
            },
          );
        }),
      ),
    );
  }

  Widget buildNormalVideoUI() {
    return Container(
      height: Get.height,
      child: Stack(
        children: <Widget>[
          buildJoinUserUI(),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 10, top: 30),
              child: FlatButton(
                minWidth: 40,
                height: 50,
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                  size: 24.0,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                color: Colors.white38,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.only(top: 0, left: 10, bottom: 10),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SignalStrengthIndicator.bars(
                    value: networkQuality,
                    size: 18,
                    barCount: 4,
                    spacing: 0.3,
                    maxValue: 4,
                    activeColor: networkQualityBarColor,
                    inactiveColor: Colors.white,
                    radius: Radius.circular(8),
                    minValue: 0,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Obx(() {
                    return Text(
                      agoraController.meetingDurationTxt.value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 2.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: GetBuilder<AgoraController>(builder: (_) {
                return Container(
                  margin: const EdgeInsets.only(right: 10, bottom: 4),
                  child: RawMaterialButton(
                    onPressed: _.onSwitchCamera,
                    child: Icon(
                      _.backCamera ? Icons.camera_rear : Icons.camera_front,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    fillColor: Colors.white38,
                  ),
                );
              })),
        ],
      ),
    );
  }

  void addLogToList(String info) {
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
  }

  int getNetworkQuality(int txQuality) {
    switch (txQuality) {
      case 0:
        return 2;
        break;
      case 1:
        return 4;
        break;
      case 2:
        return 3;
        break;
      case 3:
        return 2;
        break;
      case 4:
        return 1;
        break;
      case 4:
        return 0;
        break;
    }
    return 0;
  }

  Color getNetworkQualityBarColor(int txQuality) {
    switch (txQuality) {
      case 0:
        return Colors.green;
        break;
      case 1:
        return Colors.green;
        break;
      case 2:
        return Colors.yellow;
        break;
      case 3:
        return Colors.redAccent;
        break;
      case 4:
        return Colors.red;
        break;
      case 4:
        return Colors.red;
        break;
    }
    return Colors.yellow;
  }
}
