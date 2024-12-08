import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

String getAgoraAppId() {
  return 'ef0a2920a8414c648d0e92f553b9fd63';
  // return "<YOUR APP ID HERE>"; // Return Your Agora App Id
}

String getAgoraAppCertificate() {
  return 'd8fe908a26f54ce3b5ce471a9c1a0b27';
}

bool checkNoSignleDigit(int no) {
  int len = no.toString().length;
  if (len == 1) {
    return true;
  }
  return false;
}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

void shareToApps(String roomId) async {
  await Share.share(
    'Hey There, Lets Connect via Video call in App using code : ' + roomId,
  );
}

Future<bool> handlePermissionsForCall(BuildContext context) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
  ].request();

  // if (statuses[Permission.manageExternalStorage]?.isPermanentlyDenied ??
  //     false) {
  //   showCustomDialog(
  //     context,
  //     "Permission Required",
  //     "Storage Permission Required for Video Call",
  //     () {
  //       Navigator.pop(context);
  //       openAppSettings();
  //     },
  //   );
  //   return false;
  // }
  if (statuses[Permission.camera]?.isPermanentlyDenied ?? false) {
    showCustomDialog(
      context,
      "Permission Required",
      "Camera Permission Required for Video Call",
      () {
        Navigator.pop(context);
        openAppSettings();
      },
    );
    return false;
  } else if (statuses[Permission.microphone]?.isPermanentlyDenied ?? false) {
    showCustomDialog(
      context,
      "Permission Required",
      "Microphone Permission Required for Video Call",
      () {
        Navigator.pop(context);
        openAppSettings();
      },
    );
    return false;
  }
  print(statuses[Permission.manageExternalStorage]);

  // if (statuses[Permission.manageExternalStorage]?.isDenied ?? false) {
  //   return false;
  // } else
  if (statuses[Permission.camera]?.isDenied ?? false) {
    return false;
  } else if (statuses[Permission.microphone]?.isDenied ?? false) {
    return false;
  }
  return true;
}

void showCustomDialog(
  BuildContext context,
  String title,
  String message,
  VoidCallback okPressed,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog

      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          title,
          style: TextStyle(fontFamily: 'WorkSansMedium'),
        ),
        content: Text(
          message,
          style: TextStyle(fontFamily: 'WorkSansMedium'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "OK",
              style: TextStyle(fontFamily: 'WorkSansMedium'),
            ),
            onPressed: okPressed,
          ),
        ],
      );
    },
  );
}

int getNetworkQuality(int txQuality) {
  switch (txQuality) {
    case 0:
      return 2;

    case 1:
      return 4;

    case 2:
      return 3;

    case 3:
      return 2;

    case 4:
      return 1;

    case 4:
      return 0;
  }
  return 0;
}

Color getNetworkQualityBarColor(int txQuality) {
  switch (txQuality) {
    case 0:
      return Colors.green;
    case 1:
      return Colors.green;
    case 2:
      return Colors.yellow;
    case 3:
      return Colors.redAccent;
    case 4:
      return Colors.red;
    case 4:
      return Colors.red;
  }
  return Colors.yellow;
}
