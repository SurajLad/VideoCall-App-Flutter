import 'package:chat_app/Helpers/text_styles.dart';
import 'package:chat_app/UI/videocall_page.dart';
import 'package:flutter/material.dart';

class JoinRoomDialog extends StatefulWidget {
  @override
  _JoinRoomDialogState createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Join Room"),
      content: ListView(
        shrinkWrap: true,
        children: [
          Image.asset(
            'Assets/room_join_vector.png',
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Enter Room id to Join.",
            style: regularTxtStyle.copyWith(
                color: const Color(0xFF1A1E78), fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: const Color(0xFF1A1E78), width: 2)),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: const Color(0xFF1A1E78), width: 2))),
            style: regularTxtStyle.copyWith(
                color: const Color(0xFF1A1E78), fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            color: const Color(0xFF1A1E78),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoCallScreen(
                            channelName: "demo",
                          )));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward, color: Colors.white),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "Join Room",
                  style: regularTxtStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
