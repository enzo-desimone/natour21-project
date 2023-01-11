import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../Chat_GUI/chat_gui.dart';
import '../Controller/message_controller.dart';
import '../Controller/user_controller.dart';
import '../Dao_Class/Room/firestore_room.dart';
import 'global_variable.dart';

class OneSignalNotify {
  OneSignalNotify._privateConstructor();

  static final OneSignalNotify _instance =
      OneSignalNotify._privateConstructor();

  factory OneSignalNotify() {
    return _instance;
  }

  Future<void> initPlatformState(bool flag) async {
    try {
      await OneSignal.shared.setAppId(
        "e38c93d2-0017-4228-b528-c02c71013f78",
      );
      await OneSignal.shared
          .promptUserForPushNotificationPermission(fallbackToSettings: flag)
          .then((accepted) {});

      OneSignal.shared.setNotificationOpenedHandler(
          (OSNotificationOpenedResult result) async {
        final room = await FireStoreRoom().createRoom(await UserController()
            .getUser(result.notification.additionalData!['id_key']));
        Global().navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  room: room,
                  stream: MessageController().getMessageList(room),
                  list: const [],
                ),
              ),
            );
      });
    } catch (_) {
      //
    }
  }

  Future<String> getPlayerId() async {
    String _temp = '9rrWD2K5Kr';
    try {
      await OneSignal.shared.getDeviceState().then((deviceState) {
        if (deviceState != null) {
          _temp = deviceState.userId ?? '9rrWD2K5Kr';
        }
      });
      return _temp;
    } catch (_) {
      print(_);
      return _temp;
    }
  }
}
