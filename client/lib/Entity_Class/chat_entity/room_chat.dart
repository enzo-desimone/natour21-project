import 'package:cloud_firestore/cloud_firestore.dart';

import '../fire_base_user.dart';

class RoomChat {
  const RoomChat({
    this.createdAt,
    required this.id,
    this.avatar,
    this.name,
    required this.users,
  });

  factory RoomChat.fromJson(Map<String, dynamic> json) {
    Timestamp? _time;

    if (json['last_seen'].runtimeType.toString() != 'DateTime') {
      _time = json['last_seen'];
    }
    return RoomChat(
      createdAt: _time != null ? _time.toDate() : json['last_seen'],
      id: json['id'] as String,
      avatar: json['avatar'] as String?,
      name: json['name'] as String?,
      users: (json['users'] as List<dynamic>)
          .map((e) => FireBaseUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'created_at': createdAt,
        'id': id,
        'avatar': avatar,
        'name': name,
        'users': users.map((e) => e.toJson()).toList(),
      };

  RoomChat copyWith({
    String? avatar,
    Map<String, dynamic>? metadata,
    String? name,
    int? updatedAt,
    List<FireBaseUser>? users,
  }) {
    return RoomChat(
      id: id,
      avatar: avatar,
      name: name,
      users: users ?? this.users,
    );
  }

  List<Object?> get props => [createdAt, id, avatar, name, users];

  final DateTime? createdAt;

  final String id;

  final String? avatar;

  final String? name;

  final List<FireBaseUser> users;
}
