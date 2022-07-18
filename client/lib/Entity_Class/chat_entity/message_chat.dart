import 'package:natour21/Entity_Class/fire_base_user.dart';
import 'package:natour21/Entity_Class/chat_entity/text_message_chat.dart';
import 'package:natour21/Entity_Class/chat_entity/image_message_chat.dart';

enum MessageType { custom, file, image, text, unsupported }

enum Status { delivered, error, seen, sending, sent }

abstract class MessageChat {
  const MessageChat(
    this.author,
    this.createdAt,
    this.id,
    this.remoteId,
    this.roomId,
    this.status,
    this.type,
  );

  factory MessageChat.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'image') {
      return ImageMessageChat.fromJson(json);
    } else {
      return TextMessageChat.fromJson(json);
    }
  }

  List<Object?> get props => [
        author,
        createdAt,
        id,
        remoteId,
        roomId,
        status,
        type,
      ];

  MessageChat copyWith({
    String? remoteId,
    Status? status,
    String? text,
    String? uri,
  });

  Map<String, dynamic> toJson();

  final FireBaseUser author;

  final DateTime? createdAt;

  final String id;

  final String? remoteId;

  final String? roomId;

  final Status? status;

  final MessageType type;
}
