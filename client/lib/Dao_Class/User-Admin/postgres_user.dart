import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Dao_Class/User-Admin/firebase_user_dao.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';
import 'package:http/http.dart' as http;

class PostgresUser implements FireBaseUserDao {
  final String _username = 'raF3pBHgw6HB26Cz24Jg9V4mbFdSTTT9';
  final String _url = 'https://natour21.besimsoft.com/uq6PMpSfiZ/api/';
  final String _password = 'NMftBBs2Mm6VPAxL4ZxtFXXyntYug26R';
  String _basicAuth = '';

  PostgresUser._privateConstructor() {
    _basicAuth = 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
  }

  static final PostgresUser _instance = PostgresUser._privateConstructor();

  factory PostgresUser() => _instance;

  @override
  Future<void> signUpPostgres(String idUser) async {
    try {
      await http.post(
        Uri.parse(_url + 'user/register'),
        headers: <String, String>{'authorization': _basicAuth},
        body: {'id_key': idUser.trimAll()},
        encoding: Encoding.getByName("UTF-8"),
      );
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
  Future<void> updateAvatar(String userID, File avatarFile) {
    // TODO: implement uploadAvatar
    throw UnimplementedError();
  }

  @override
  Future<void> updateFirstLogin(String userID) {
    // TODO: implement updateFirstLogin
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(String userID, String firstName, String lastName,
      String bornDate, String gender, String? email) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<FireBaseUser> getUser(String userId) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword(String password, BuildContext context) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Stream<List<FireBaseUser>> getUserList() {
    // TODO: implement getUserList
    throw UnimplementedError();
  }

  @override
  Stream<FireBaseUser> getStreamUser() {
    // TODO: implement getStreamUser
    throw UnimplementedError();
  }
}
