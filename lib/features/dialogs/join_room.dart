import 'package:chat_app/utils/utils.dart';
import 'package:chat_app/features/video_call/view/video_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../design_system/text_styles.dart';

class JoinRoomBottomSheet extends StatelessWidget {
  final TextEditingController roomTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Text(
              "Please enter Meeting Room Id to Join :",
              style: AppTextStyles.regular.copyWith(
                color: const Color(0xFF1A1E78),
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
            ElevatedButton.icon(
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
                Icons.arrow_forward,
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
          ],
        ),
      ),
    );
  }
}
