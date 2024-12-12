import 'package:chat_app/features/create_join_room/join_room_page.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:chat_app/features/video_call/view/video_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../design_system/text_styles.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  String roomId = "";
  @override
  void initState() {
    roomId = generateRandomString(8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Room",
          style: AppTextStyles.medium.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1E78),
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(
            "Voilà!, We have created an personal room for you",
            style: AppTextStyles.regular.copyWith(
              color: const Color(0xFF1A1E78),
            ),
          ),
          const SizedBox(height: 16),
          Image.asset(
            'assets/room_created_vector.png',
            height: MediaQuery.of(context).size.width * 0.85,
          ),
          Text(
            "Room id : " + roomId,
            style: AppTextStyles.medium.copyWith(
              color: const Color(0xFF1A1E78),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                label: Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  backgroundColor: const Color(0xFF1A1E78),
                ),
                onPressed: () {
                  shareToApps(roomId);
                },
                icon: Text(
                  "  Share  ",
                  style: AppTextStyles.regular,
                ),
              ),
              const SizedBox(width: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  bool isPermissionGranted =
                      await handlePermissionsForCall(context);
                  if (isPermissionGranted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoCallScreen(
                          channelName: roomId,
                        ),
                      ),
                    );
                  } else {
                    Get.snackbar(
                      "Failed",
                      "Microphone Permission Required for Video Call.",
                      backgroundColor: Colors.white,
                      colorText: Color(0xFF1A1E78),
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(milliseconds: 1000),
                      animationDuration: Duration(milliseconds: 750),
                    );
                  }
                },
                label: Icon(
                  Icons.login,
                  color: Colors.white,
                  size: 18,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  backgroundColor: const Color(0xFF1A1E78),
                ),
                icon: Text(
                  "Join Room",
                  style: AppTextStyles.regular,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            margin: const EdgeInsets.only(left: 24, right: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1E78),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => JoinRoomPage(),
                ),
              );
            },
            label: Icon(
              Icons.open_in_new,
              color: Colors.white,
              size: 18,
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              backgroundColor: const Color(0xFF1A1E78),
            ),
            icon: Text(
              "Join another room",
              style: AppTextStyles.regular,
            ),
          ),
        ],
      ),
    );
  }
}
