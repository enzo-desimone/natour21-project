import 'package:flutter/material.dart';
import 'package:natour21/Accessory_GUI/custom_dialog.dart';

import 'package:natour21/Chat_GUI/chat_gui.dart';
import 'package:natour21/Dao_Class/Room/firestore_room.dart';
import 'package:natour21/Entity_Class/chat_entity/room_chat.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';

import '../Accessory_Class/global_variable.dart';
import 'message_controller.dart';

class RoomController {
  RoomController._privateConstructor();

  static final RoomController _instance = RoomController._privateConstructor();

  factory RoomController() => _instance;

  Future<RoomChat> startChat(FireBaseUser user, BuildContext context) async {
    CustomAlertDialog.loadingScreen(context, null);
    await Global.analytics.logEvent(
      name: 'request_itinerary_info_event',
      parameters: <String, dynamic>{
        'user': Global().myUser.value.id,
      },
    );
    final room = await FireStoreRoom().createRoom(user);
    Navigator.of(context).pop();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
          stream: MessageController().getMessageList(room),
          list: const [],
        ),
      ),
    );
    return room;
  }

  Stream<List<RoomChat>> getRooms() {
    return FireStoreRoom().getRooms();
  }

  Future<void> deleteRoom(String roomID) async {
    await FireStoreRoom().deleteRoom(roomID);
  }
}
