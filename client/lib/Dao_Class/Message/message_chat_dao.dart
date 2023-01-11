import 'package:natour21/Entity_Class/chat_entity/message_chat.dart';
import 'package:natour21/Entity_Class/chat_entity/room_chat.dart';
import 'package:natour21/Entity_Class/chat_entity/text_message_chat.dart';

abstract class MessageChatDao {
  Stream<List<MessageChat>> getMessageList(RoomChat room);

  Future<void> sendMessage(PartialText text, String roomID);

  Future<void> sendImage(String roomID, result);

  void updateMessage(MessageChat message, String roomID);
}
