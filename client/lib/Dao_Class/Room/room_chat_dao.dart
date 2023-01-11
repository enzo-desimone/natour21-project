import 'package:natour21/Entity_Class/chat_entity/room_chat.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';

abstract class RoomChatDao {
  Future<void> createRoom(FireBaseUser user);

  Stream<List<RoomChat>> getRooms();

  Future<void> deleteRoom(String roomID);
}
