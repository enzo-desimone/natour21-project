import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Dao_Class/User-Admin/firebase_user_dao.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';

class FireStoreUser implements FireBaseUserDao {
  var _mock;

  FireStoreUser._privateConstructor();

  static final FireStoreUser _instance = FireStoreUser._privateConstructor();

  factory FireStoreUser({var mock}) {
    _instance._mock = mock ?? FirebaseFirestore.instance;
    return _instance;
  }

  @override
  Future<FireBaseUser> getUser(String userId) async {
    FireBaseUser _temp = FireBaseUser();

    await _mock.collection('users').doc(userId).get().then((value) {
      _temp = FireBaseUser.fromJson(value.data());
      _temp.setId = userId;
    });
    return _temp;
  }

  @override
  Stream<FireBaseUser> getStreamUser() {
    Stream<DocumentSnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance
        .collection('users')
        .doc(Global().myUser.value.id)
        .snapshots();

    return stream.map((event) {
      FireBaseUser _user = FireBaseUser.fromJson(event.data());
      _user.setEmail = Global().myUser.value.email!;
      _user.setId = event.id;
      Global().myUser.value = _user;
      return _user;
    });
  }

  @override
  Stream<List<FireBaseUser>> getUserList() {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream =
        _mock.collection('users').snapshots();

    return stream
        .map<List<FireBaseUser>>((qShot) => qShot.docs.map<FireBaseUser>((doc) {
              FireBaseUser _user = FireBaseUser.fromJson(doc.data());
              _user.setId = doc.id;
              return _user;
            }).toList());
  }

  @override
  Future<bool> updateAvatar(String? userID, File? avatarFile) async {
    if (userID == null) {
      return false;
    }

    if (avatarFile == null) {
      await _mock.collection('users').doc(userID).update({
        'first_login': false,
      });
      return false;
    }

    String path = 'avatar/' + userID + getRandomString(20) + '.png';

    try {
      var collectionRef;
      var doc;

      if (_mock.runtimeType.toString() == 'FakeFirebaseFirestore') {
        collectionRef = await _mock.collection('users').get();
        doc = collectionRef.docs.first.get('username') == userID ? userID : '';
        if (!doc.isNotEmpty) {
          return false;
        } else {
          return true;
        }
      } else {
        collectionRef = _mock.collection('users');
        doc = await collectionRef.doc(userID).get();

        if (!doc.exists) {
          return false;
        } else {
          await FirebaseStorage.instance.ref(path).putFile(avatarFile);
          await _mock.collection('users').doc(userID).update({
            'first_login': false,
            'avatar': (await (FirebaseStorage.instance.ref().child(path))
                    .getDownloadURL())
                .toString(),
          });

          await _mock
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) {
            Global().myUser.value = FireBaseUser.fromJson(value.data());
            Global().myUser.value.setId =
                FirebaseAuth.instance.currentUser!.uid;
            Global().myUser.value.setEmail =
                FirebaseAuth.instance.currentUser!.email!;
          });
          return true;
        }
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateUser(String userID, String firstName, String lastName,
      String bornDate, String gender, String? email) async {
    try {
      if (email == null) {
        await _mock.collection('users').doc(userID).update({
          'first_name': firstName,
          'last_name': lastName,
          'born_date': bornDate,
          'gender': gender,
        });
        Global().myUser.value.setFirstName = firstName;
        Global().myUser.value.setLastName = lastName;
        Global().myUser.value.setBornDate = bornDate;
        Global().myUser.value.setGender = gender;
      } else {
        var _credential = EmailAuthProvider.credential(
            email: (await Global().storage.read(key: 'email'))!,
            password: (await Global().storage.read(key: 'password'))!);

        var result = await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(_credential);

        result.user?.updateEmail(email);
        await _mock.collection('users').doc(userID).update({
          'email': email,
        });

        await Global().storage.write(key: 'email', value: email);
        Global().myUser.value.setEmail = email;
      }
    } catch (e) {
      //
    }
  }

  @override
  Future<void> updateFirstLogin(String userID) async {
    try {
      await _mock.collection('users').doc(userID).update({
        'first_login': false,
      });
    } catch (e) {
      //
    }
  }

  @override
  Future<String> loginWithEmail(String username, String password) {
    // TODO: implement loginUser
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<bool> reauthenticateUser(String provider) {
    // TODO: implement reauthenticateUser
    throw UnimplementedError();
  }

  @override
  Future<String> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<UserCredential?> loginWithSocial(String provider) {
    // TODO: implement loginWithSocial
    throw UnimplementedError();
  }

  @override
  Future<String> signUpFireBaseUser(
      String firstName,
      String lastName,
      String bornDate,
      String gender,
      String email,
      String? password,
      String? avatar,
      String? userID,
      String provider) {
    // TODO: implement signUpFireBaseUser
    throw UnimplementedError();
  }

  @override
  Future<void> signUpPostgres(String idUser) {
    // TODO: implement signUpPostgres
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword(String password, BuildContext context) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }
}
