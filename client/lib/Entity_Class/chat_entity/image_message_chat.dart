import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';

import 'message_chat.dart';

class ImageMessageChat extends MessageChat {
  const ImageMessageChat({
    required FireBaseUser author,
    DateTime? createdAt,
    this.height,
    required String id,
    required this.name,
    String? remoteId,
    String? roomId,
    required this.size,
    Status? status,
    MessageType? type,
    required this.uri,
    this.width,
  }) : super(
          author,
          createdAt,
          id,
          remoteId,
          roomId,
          status,
          type ?? MessageType.image,
        );

  ImageMessageChat.fromPartial({
    required FireBaseUser author,
    DateTime? createdAt,
    required String id,
    required PartialImage partialImage,
    String? remoteId,
    String? roomId,
    Status? status,
  })  : height = partialImage.height,
        name = partialImage.name,
        size = partialImage.size,
        uri = partialImage.uri,
        width = partialImage.width,
        super(
          author,
          createdAt,
          id,
          remoteId,
          roomId,
          status,
          MessageType.image,
        );

  factory ImageMessageChat.fromJson(Map<String, dynamic> json) {
    Timestamp? _time = json['createdAt'];

    if (json['createdAt'].runtimeType.toString() != 'DateTime') {
      _time = json['createdAt'];
    }
    return ImageMessageChat(
      author: FireBaseUser.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: _time != null ? _time.toDate() : json['createdAt'],
      height: (json['height'] as num?)?.toDouble(),
      id: json['id'] as String,
      name: json['name'] as String,
      remoteId: json['remoteId'] as String?,
      roomId: json['roomId'] as String?,
      size: json['size'] as num,
      status: EnumToString.fromString(Status.values, json['status']),
      type: EnumToString.fromString(MessageType.values, json['type']),
      uri: json['uri'] as String,
      width: (json['width'] as num?)?.toDouble(),
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
        'height': height,
        'name': name,
        'size': size,
        'uri': uri,
        'width': width,
      };

  @override
  MessageChat copyWith({
    String? remoteId,
    Status? status,
    String? text,
    String? uri,
  }) {
    return ImageMessageChat(
      author: author,
      createdAt: createdAt,
      height: height,
      id: id,
      name: name,
      remoteId: remoteId,
      roomId: roomId,
      size: size,
      status: status ?? this.status,
      uri: uri ?? this.uri,
      width: width,
    );
  }

  @override
  List<Object?> get props => [
        author,
        createdAt,
        height,
        id,
        name,
        remoteId,
        roomId,
        size,
        status,
        uri,
        width,
      ];

  final double? height;

  final String name;

  final num size;

  final String uri;

  final double? width;
}

class PartialImage {
  final double? height;

  final String name;

  final num size;

  final String uri;

  final double? width;

  const PartialImage({
    this.height,
    required this.name,
    required this.size,
    required this.uri,
    this.width,
  });

  factory PartialImage.fromJson(Map<String, dynamic> json) => PartialImage(
        height: (json['height'] as num?)?.toDouble(),
        name: json['name'] as String,
        size: json['size'] as num,
        uri: json['uri'] as String,
        width: (json['width'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'height': height,
        'name': name,
        'size': size,
        'uri': uri,
        'width': width,
      };
}
