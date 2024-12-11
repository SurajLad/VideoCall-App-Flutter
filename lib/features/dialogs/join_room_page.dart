import 'package:chat_app/features/dialogs/create_room_page.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:chat_app/features/video_call/view/video_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../design_system/text_styles.dart';

class JoinRoomPage extends StatelessWidget {
  final TextEditingController roomTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Join Room",
          style: AppTextStyles.medium.copyWith(
            color: const Color(0xFF1A1E78),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                "Please enter Meeting Room Id",
                style: AppTextStyles.regular.copyWith(
                  color: const Color(0xFF1A1E78),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/room_join_vector.png',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: TextFormField(
                controller: roomTxtController,
                decoration: InputDecoration(
                  hintText: "Room Id :",
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: const Color(0xFF1A1E78), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: const Color(0xFF1A1E78), width: 2),
                  ),
                ),
                style: AppTextStyles.regular.copyWith(
                  color: const Color(0xFF1A1E78),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (roomTxtController.text.isNotEmpty) {
                    bool isPermissionGranted =
                        await handlePermissionsForCall(context);
                    if (isPermissionGranted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoCallScreen(
                            channelName: roomTxtController.text,
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
                        duration: Duration(milliseconds: 1500),
                      );
                    }
                  } else {
                    Get.snackbar(
                      "Failed",
                      "Enter Room-Id to Join.",
                      backgroundColor: Colors.white,
                      colorText: Color(0xFF1A1E78),
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(milliseconds: 1500),
                    );
                  }
                },
                label: Icon(
                  Icons.login_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: const Color(0xFF1A1E78),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "Join Room",
                    style: AppTextStyles.regular,
                  ),
                ),
              ),
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
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                "Dont have room id ? \nCreate your own personal room",
                style: AppTextStyles.regular.copyWith(
                  color: const Color(0xFF1A1E78),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateRoomPage(),
                    ),
                  );
                },
                label: Icon(
                  Icons.create_new_folder,
                  color: Colors.white,
                  size: 18,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  backgroundColor: const Color(0xFF1A1E78),
                ),
                icon: Text(
                  "Create personal room",
                  style: AppTextStyles.regular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
