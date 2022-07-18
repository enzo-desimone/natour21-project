import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:natour21/Dao_Class/Room/room_chat_dao.dart';
import 'package:natour21/Entity_Class/chat_entity/room_chat.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';

class FireStoreRoom implements RoomChatDao {
  FireStoreRoom._privateConstructor();

  static final FireStoreRoom _instance = FireStoreRoom._privateConstructor();

  factory FireStoreRoom() => _instance;

  @override
  Future<RoomChat> createRoom(FireBaseUser otherUser) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return Future.error('User-Admin does not exist');

    List<String> list = [];

    list.add(user.uid);
    list.add(otherUser.id!);

    QuerySnapshot<Map<String, dynamic>> snapshotOne = await FirebaseFirestore
        .instance
        .collection('rooms')
        .where('users', isEqualTo: list)
        .get();

    bool firstIsEmpty = snapshotOne.docs.isEmpty;

    list.clear();

    list.add(otherUser.id!);
    list.add(user.uid);

    QuerySnapshot<Map<String, dynamic>> snapshotTwo = await FirebaseFirestore
        .instance
        .collection('rooms')
        .where('users', isEqualTo: list)
        .get();

    bool secondIsEmpty = snapshotTwo.docs.isEmpty;

    if (firstIsEmpty && secondIsEmpty) {
      final query = await FirebaseFirestore.instance
          .collection('rooms')
          .where('users', arrayContains: user.uid)
          .get();
      final rooms = query.docs.map(
        (doc) => processRoomDocument(
          doc,
          user,
          'users',
        ),
      );

      try {
        return rooms.firstWhere((room) {
          final userIds = room.then((value) => value.users.map((u) => u.id));

          late String _user;
          userIds.then((value) => _user = value.toString());

          return _user.contains(user.uid) && _user.contains(otherUser.id!);
        });
      } catch (e) {
        //
      }

      final currentUser = await fetchUser(
        user.uid,
        'users',
      );

      final users = [FireBaseUser.fromJson(currentUser), otherUser];

      final room = await FirebaseFirestore.instance.collection('rooms').add({
        'created_at': Timestamp.now(),
        'users': users.map((u) => u.id).toList(),
      });

      return RoomChat(
        id: room.id,
        avatar: otherUser.avatar,
        name: otherUser.firstName!.capitalizeFirstOfEach +
            ' ' +
            otherUser.lastName!.capitalizeFirstOfEach,
        users: users,
      );
    } else {
      final users = [Global().myUser.value, otherUser];
      if (firstIsEmpty) {
        return RoomChat(
          id: snapshotTwo.docs[0].reference.id,
          avatar: otherUser.avatar,
          name: otherUser.firstName!.capitalizeFirstOfEach +
              ' ' +
              otherUser.lastName!.capitalizeFirstOfEach,
          users: users,
        );
      } else {
        return RoomChat(
          id: snapshotOne.docs[0].reference.id,
          avatar: otherUser.avatar,
          name: otherUser.firstName!.capitalizeFirstOfEach +
              ' ' +
              otherUser.lastName!.capitalizeFirstOfEach,
          users: users,
        );
      }
    }
  }

  @override
  Stream<List<RoomChat>> getRooms() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const Stream.empty();

    final collection = FirebaseFirestore.instance
        .collection('rooms')
        .where('users', arrayContains: user.uid);

    var _temp = collection.snapshots().asyncMap(
          (query) => processRoomsQuery(
            user,
            query,
            'users',
          ),
        );

    return _temp;
  }

  @override
  Future<void> deleteRoom(String roomID) async {
    await FirebaseFirestore.instance.collection('rooms').doc(roomID).delete();
  }

  Future<RoomChat> processRoomDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    User firebaseUser,
    String usersCollectionName,
  ) async {
    final data = doc.data()!;

    data['created_at'] = data['created_at'];
    data['id'] = doc.id;

    var imageUrl = data['avatar'] as String?;
    var name = data['name'] as String?;
    final userIds = data['users'] as List<dynamic>;

    final users = await Future.wait(
      userIds.map(
        (userId) => fetchUser(
          userId as String,
          usersCollectionName,
        ),
      ),
    );

    try {
      final otherUser = users.firstWhere(
        (u) => u['id'] != firebaseUser.uid,
      );

      imageUrl = otherUser['avatar'] as String?;
      name = '${otherUser['first_name'] ?? ''} ${otherUser['last_name'] ?? ''}'
          .trim();
    } catch (e) {
      //
    }

    data['avatar'] = imageUrl;
    data['name'] = name;
    data['users'] = users;
    return RoomChat.fromJson(data);
  }

  Future<Map<String, dynamic>> fetchUser(
      String userId, String usersCollectionName) async {
    final doc = await FirebaseFirestore.instance
        .collection(usersCollectionName)
        .doc(userId)
        .get();

    final data = doc.data()!;

    data['created_at'] = data['created_at'];
    data['id'] = doc.id;
    data['last_seen'] = data['last_seen'];
    return data;
  }

  Future<List<RoomChat>> processRoomsQuery(
    User firebaseUser,
    QuerySnapshot<Map<String, dynamic>> query,
    String usersCollectionName,
  ) async {
    final futures = query.docs.map(
      (doc) => processRoomDocument(
        doc,
        firebaseUser,
        usersCollectionName,
      ),
    );
    return await Future.wait(futures);
  }
}
