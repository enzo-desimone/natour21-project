import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';

abstract class FireBaseUserDao {
  Future<String> loginWithEmail(String username, String password);

  Future<UserCredential?> loginWithSocial(String provider);

  Future<String> signUpFireBaseUser(
      String firstName,
      String lastName,
      String bornDate,
      String gender,
      String email,
      String? password,
      String? avatar,
      String? userID,
      String provider);

  Future<void> signUpPostgres(String idUser);

  Future<bool> reauthenticateUser(String provider);

  Future<bool> logout();

  Future<void> updatePassword(String password, BuildContext context);

  Future<String> resetPassword(String email);

  Future<void> updateUser(String userID, String firstName, String lastName,
      String bornDate, String gender, String? email);

  Future<void> updateFirstLogin(String userID);

  Future<void> updateAvatar(String userID, File avatarFile);

  Future<FireBaseUser> getUser(String userId);

  Stream<FireBaseUser> getStreamUser();

  Stream<List<FireBaseUser>> getUserList();
}
