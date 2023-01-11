import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natour21/Dao_Class/Message/message_chat_dao.dart';
import 'package:natour21/Entity_Class/chat_entity/image_message_chat.dart';
import 'package:natour21/Entity_Class/chat_entity/message_chat.dart';
import 'package:natour21/Entity_Class/chat_entity/room_chat.dart';
import 'package:natour21/Entity_Class/chat_entity/text_message_chat.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/painting.dart';

class FireStoreMessage implements MessageChatDao {
  FireStoreMessage._privateConstructor();

  static final FireStoreMessage _instance =
      FireStoreMessage._privateConstructor();

  factory FireStoreMessage() => _instance;

  @override
  Stream<List<MessageChat>> getMessageList(RoomChat room) {
    return FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.fold<List<MessageChat>>(
          [],
          (previousValue, doc) {
            final data = doc.data();
            final author = room.users.firstWhere(
              (u) => u.id == data['authorId'],
              orElse: () => FireBaseUser(id: data['authorId'] as String),
            );

            data['author'] = author.toJson();
            data['createdAt'] = data['createdAt'];
            data['id'] = doc.id;
            return [...previousValue, MessageChat.fromJson(data)];
          },
        );
      },
    );
  }

  @override
  Future<bool> sendMessage(PartialText text, String roomID) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return false;

    MessageChat message = TextMessageChat.fromPartial(
      author: FireBaseUser(id: user.uid),
      id: '',
      partialText: text,
    );

    final messageMap = message.toJson();
    messageMap.removeWhere((key, value) => key == 'author' || key == 'id');
    messageMap['authorId'] = user.uid;
    messageMap['createdAt'] = Timestamp.now();
    messageMap['status'] = 'sent';
    messageMap['type'] = 'text';

    try {
      await FirebaseFirestore.instance
          .collection('rooms/$roomID/messages')
          .add(messageMap);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void updateMessage(MessageChat message, String roomId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;
    if (message.author.id == user.uid) return;

    final messageMap = message.toJson();
    messageMap.removeWhere(
        (key, value) => key == 'author' || key == 'createdAt' || key == 'id');
    messageMap['authorId'] = message.author.id;
    messageMap['status'] = 'seen';
    if (message.type.toString() == 'MessageType.text') {
      messageMap['type'] = 'text';
    } else {
      messageMap['type'] = 'image';
    }

    await FirebaseFirestore.instance
        .collection('rooms/$roomId/messages')
        .doc(message.id)
        .update(messageMap);
  }

  @override
  Future<void> sendImage(String roomID, result) async {
    if (result != null) {
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final path = 'chat_image/' + result.name;

      try {
        final reference = FirebaseStorage.instance.ref(path);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final user = FirebaseAuth.instance.currentUser;

        if (user == null) return;

        MessageChat message = ImageMessageChat.fromPartial(
          author: FireBaseUser(id: user.uid),
          id: '',
          partialImage: PartialImage(
            height: image.height.toDouble(),
            name: result.name,
            size: size,
            uri: uri,
            width: image.width.toDouble(),
          ),
        );

        final messageMap = message.toJson();
        messageMap.removeWhere((key, value) => key == 'author' || key == 'id');
        messageMap['authorId'] = user.uid;
        messageMap['createdAt'] = Timestamp.now();
        messageMap['type'] = 'image';
        messageMap['status'] = 'sent';

        await FirebaseFirestore.instance
            .collection('${'rooms'}/$roomID/messages')
            .add(messageMap);
      } catch (_) {
        //
      }
    }
  }
}
