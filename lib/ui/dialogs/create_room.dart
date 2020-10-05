import 'package:chat_app/helpers/text_styles.dart';
import 'package:chat_app/helpers/utils.dart';
import 'package:chat_app/UI/videocall_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRoomDialog extends StatefulWidget {
  @override
  _CreateRoomDialogState createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  String roomId = "";
  @override
  void initState() {
    roomId = generateRandomString(8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Room Created"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'Assets/room_created_vector.png',
          ),
          Text(
            "Room id : " + roomId,
            style: midTxtStyle.copyWith(color: const Color(0xFF1A1E78)),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                color: const Color(0xFF1A1E78),
                onPressed: () {
                  shareToApps(roomId);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share, color: Colors.white),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Share",
                      style: regularTxtStyle,
                    ),
                  ],
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                color: const Color(0xFF1A1E78),
                onPressed: () async {
                  bool isPermissionGranted =
                      await handlePermissionsForCall(context);
                  if (isPermissionGranted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoCallScreen(
                                  channelName: roomId,
                                )));
                  } else {
                    Get.snackbar("Failed",
                        "Microphone Permission Required for Video Call.",
                        backgroundColor: Colors.white,
                        colorText: Color(0xFF1A1E78),
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward, color: Colors.white),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Join",
                      style: regularTxtStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
