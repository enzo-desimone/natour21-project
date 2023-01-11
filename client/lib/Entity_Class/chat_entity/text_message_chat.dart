import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';
import 'message_chat.dart';

class TextMessageChat extends MessageChat {
  final String text;

  const TextMessageChat({
    required FireBaseUser author,
    DateTime? createdAt,
    required String id,
    String? remoteId,
    String? roomId,
    Status? status,
    required this.text,
    MessageType? type,
  }) : super(
          author,
          createdAt,
          id,
          remoteId,
          roomId,
          status,
          type ?? MessageType.text,
        );

  TextMessageChat.fromPartial({
    required FireBaseUser author,
    DateTime? createdAt,
    required String id,
    String? remoteId,
    String? roomId,
    Status? status,
    required PartialText partialText,
  })  : text = partialText.text,
        super(
            author, createdAt, id, remoteId, roomId, status, MessageType.text);

  factory TextMessageChat.fromJson(Map<String, dynamic> json) {
    Timestamp? _time;

    if (json['createdAt'].runtimeType.toString() != 'DateTime') {
      _time = json['createdAt'];
    }

    return TextMessageChat(
      author: FireBaseUser.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: _time != null ? _time.toDate() : json['createdAt'],
      id: json['id'] as String,
      remoteId: json['remoteId'] as String?,
      roomId: json['roomId'] as String?,
      status: EnumToString.fromString(Status.values, json['status']),
      text: json['text'] as String,
      type: EnumToString.fromString(MessageType.values, json['type']),
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'author': author.toJson(),
        'createdAt': createdAt,
        'id': id,
        'remoteId': remoteId,
        'roomId': roomId,
        'status': status,
        'type': type,
        'text': text,
      };

  @override
  MessageChat copyWith({
    String? remoteId,
    Status? status,
    String? text,
    String? uri,
  }) {
    return TextMessageChat(
      author: author,
      createdAt: createdAt,
      id: id,
      remoteId: remoteId,
      roomId: roomId,
      status: status ?? this.status,
      text: text ?? this.text,
    );
  }

  @override
  List<Object?> get props => [
        author,
        createdAt,
        id,
        remoteId,
        roomId,
        status,
        text,
      ];

  String getText() {
    return text;
  }
}

class PartialText {
  final String text;

  const PartialText({
    required this.text,
  });

  factory PartialText.fromJson(Map<String, dynamic> json) => PartialText(
        text: json['text'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'text': text,
      };
}
