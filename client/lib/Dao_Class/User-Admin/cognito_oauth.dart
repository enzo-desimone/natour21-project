import 'dart:io';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Dao_Class/User-Admin/firebase_user_dao.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CognitoOauth implements FireBaseUserDao {
  final userPool =
      CognitoUserPool('eu-west-2_TwWWS64U5', '2kacsm422ouvljgdq6iefdvfia');

  CognitoOauth._privateConstructor();

  static final CognitoOauth _instance = CognitoOauth._privateConstructor();

  factory CognitoOauth() => _instance;

  @override
  Future<String> loginWithEmail(String email, String password) async {
    final authDetails = AuthenticationDetails(
      username: email,
      password: password,
    );
    final cognitoUser = CognitoUser(email, userPool);

    try {
      CognitoUserSession? session =
          await cognitoUser.authenticateUser(authDetails);
      List<CognitoUserAttribute>? attributes;

      try {
        attributes = await cognitoUser.getUserAttributes();
        await Global()
            .storage
            .write(key: 'tokenAuth', value: session?.getIdToken().jwtToken);

        Global().myAdmin.setId = attributes![0].value!;
        Global().myAdmin.setFirstName = attributes[2].value!;
        Global().myAdmin.setLastName = attributes[3].value!;
        Global().myAdmin.setEmail = attributes[4].value!;
        Global().myAdmin.setPassword = password;

        await Global().storage.write(key: 'email', value: email);
        await Global().storage.write(key: 'password', value: password);

        return 'true';
      } catch (e) {
        return 'Attenzione, errore generico';
      }
    } on CognitoUserNewPasswordRequiredException {
      return 'Attenzione, l\'utente ha bisogno di una nuova password';
    } on CognitoUserMfaRequiredException {
      return 'Attenzione, l\'utente necessita dell\'autenticazione a due fattori';
    } on CognitoUserSelectMfaTypeException {
      return 'Attenzione, selezione il tipo di autenticazione a due fattori';
    } on CognitoUserMfaSetupException {
      return 'Attenzione, errore generico';
    } on CognitoUserTotpRequiredException {
      return 'Attenzione, errore generico';
    } on CognitoUserCustomChallengeException {
      return 'Attenzione, errore generico';
    } on CognitoUserConfirmationNecessaryException {
      return 'Attenzione, l\'utente non è ancora stato confermato';
    } on CognitoClientException {
      return 'Attenzione, username o password errati';
    } catch (e) {
      return 'Attenzione, errore generico';
    }
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
  Future<void> signUpPostgres(String idUser) {
    // TODO: implement signUpPostgres
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
  Future<UserCredential?> loginWithSocial(String provider) {
    // TODO: implement loginWithSocial
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() async {
    SharedPreferences _save = await SharedPreferences.getInstance();
    try {
      final cognitoUser =
          CognitoUser(await Global().storage.read(key: 'email'), userPool);
      await cognitoUser.signOut();
      return true;
    } catch (e) {
      return false;
    }
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
