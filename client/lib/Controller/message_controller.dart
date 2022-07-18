import 'package:flutter/cupertino.dart';
import 'package:natour21/Dao_Class/Message/firestore_message.dart';
import 'package:natour21/Entity_Class/chat_entity/message_chat.dart';
import 'package:natour21/Entity_Class/chat_entity/room_chat.dart';
import 'package:natour21/Entity_Class/chat_entity/text_message_chat.dart';

import '../Accessory_Class/global_variable.dart';
import '../Accessory_GUI/custom_dialog.dart';

class MessageController {
  MessageController._privateConstructor();

  static final MessageController _instance =
      MessageController._privateConstructor();

  factory MessageController() => _instance;

  Stream<List<MessageChat>> getMessageList(RoomChat room) {
    return FireStoreMessage().getMessageList(room);
  }

  Future<bool> sendMessage(PartialText text, String roomID) async {
    return await FireStoreMessage().sendMessage(text, roomID);
  }

  Future<void> sendImage(String roomID, result, BuildContext context) async {
    CustomAlertDialog.loadingScreen(context, null);
    await FireStoreMessage().sendImage(roomID, result);
    Navigator.pop(Global().navigatorKey.currentContext!);
  }

  void updateMessage(MessageChat message, String roomID) {
    FireStoreMessage().updateMessage(message, roomID);
  }
}
