import 'package:chat_app/features/dialogs/create_room.dart';
import 'package:chat_app/features/dialogs/join_room.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/design_system/text_styles.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E78),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60, left: 30),
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "VideoChat App",
                  style:
                      AppTextStyles.large.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  "Easy connect with friends via video call.",
                  style:
                      AppTextStyles.large.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                top: 30,
              ),
              padding: const EdgeInsets.only(
                top: 30,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Center(
                  child: Column(
                children: [
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return CreateRoomDialog();
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Flexible(
                              flex: 7,
                              child: Image.asset(
                                "assets/create_meeting_vector.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Create Room",
                                    style: AppTextStyles.large.copyWith(
                                        color: const Color(0xFF1A1E78)),
                                  ),
                                  Text(
                                    "create a unique agora room and ask others to join the same.",
                                    style: AppTextStyles.regular.copyWith(
                                        color: const Color(0xFF1A1E78)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 2,
                        margin: const EdgeInsets.all(20),
                        color: const Color(0xFF1A1E78)),
                  ),
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return JoinRoomDialog();
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Flexible(
                                flex: 6,
                                child: Image.asset(
                                  "assets/join_meeting_vector.png",
                                  fit: BoxFit.fill,
                                )),
                            Flexible(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Join Room",
                                    style: AppTextStyles.large.copyWith(
                                        color: const Color(0xFF1A1E78)),
                                  ),
                                  Text(
                                    "Join a agora room created by your friend.",
                                    style: AppTextStyles.regular.copyWith(
                                        color: const Color(0xFF1A1E78)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A1E78),
        child: Icon(Icons.thumb_up_alt_outlined),
        onPressed: () {
          Get.snackbar("You Liked ?", "Please ★ My Project On Git :) ",
              backgroundColor: Colors.white,
              colorText: Color(0xFF1A1E78),
              snackPosition: SnackPosition.BOTTOM);
        },
      ),
    );
  }
}
