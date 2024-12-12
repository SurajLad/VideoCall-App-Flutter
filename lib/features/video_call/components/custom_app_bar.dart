import 'package:chat_app/design_system/text_styles.dart';
import 'package:chat_app/features/video_call/controller/video_call_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.agoraController})
      : super(key: key);
  final AgoraController agoraController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Obx(
        () {
          final duration = agoraController.meetingDurationTxt.value;
          return Text(
            'Meeting Duration : ${duration}',
            style: AppTextStyles.regular.copyWith(color: Colors.black),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
