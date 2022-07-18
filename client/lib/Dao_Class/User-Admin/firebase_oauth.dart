import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Dao_Class/User-Admin/firebase_user_dao.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';

import '../../Accessory_GUI/custom_dialog.dart';

class FirebaseOauth implements FireBaseUserDao {
  FirebaseOauth._privateConstructor();

  static final FirebaseOauth _instance = FirebaseOauth._privateConstructor();

  factory FirebaseOauth() => _instance;

  @override
  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        Global().myUser.value = FireBaseUser.fromJson(value.data());
        Global().myUser.value.setId = FirebaseAuth.instance.currentUser!.uid;
        Global().myUser.value.setEmail =
            FirebaseAuth.instance.currentUser!.email!;
        Global().myUser.value.setLastSeen = (Timestamp.now()).toDate();
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'last_seen': Timestamp.now(),
        'login_counter': Global().myUser.value.loginCounter! + 1
      });

      await Global().storage.write(key: 'email', value: email);
      await Global().storage.write(key: 'password', value: password);
      return 'true';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return "Attenzione, il formata dell'email non è valido.";

        case "wrong-password":
          return "Attenzione, la password che hai inserito non è corretta.";

        case "user-not-found":
          return "Attenzione, l'email inserita non è ancora registrata.";

        case "user-disabled":
          return "Attenzione, l'utente non è abilitato ad utilizzare l'app, contatta il supporto tecnico.";

        case "too-many-requests":
          return "Attenzione, sono stati eseguiti troppi tentativi di accesso, riprova più tardi.";

        case "operation-not-allowed":
          return "Attenzione, il login_signup tramite email e password non è abilitato";

        default:
          return "Attenzione, non è stato possibile eseguire la richiesta, riprova.";
      }
    }
  }

  @override
  Future<UserCredential?> loginWithSocial(String provider) async {
    if (provider == 'facebook.com') {
      final LoginResult loginResult;
      try {
        loginResult = await FacebookAuth.instance.login();
        final _json = await FacebookAuth.instance.getUserData(
          fields: " first_name,last_name,email,picture.width(1500) ",
        );
        Global().myUser.value = FireBaseUser.fromJsonFacebook(_json);

        final firebaseOauth = FirebaseAuth.instance.signInWithCredential(
            FacebookAuthProvider.credential(loginResult.accessToken!.token));

        await Global()
            .storage
            .write(key: 'tokenFacebook', value: loginResult.accessToken!.token);
        return firebaseOauth;
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      final GoogleSignInAccount? googleUser;
      try {
        googleUser = await GoogleSignIn().signIn();
        final firebaseOauth = FirebaseAuth.instance
            .signInWithCredential(GoogleAuthProvider.credential(
          accessToken: (await googleUser?.authentication)!.accessToken,
          idToken: (await googleUser?.authentication)!.idToken,
        ));

        await Global().storage.write(
            key: 'accessToken',
            value: (await googleUser?.authentication)!.accessToken);
        await Global().storage.write(
            key: 'idToken',
            value: (await googleUser?.authentication)!.idToken!);

        return firebaseOauth;
      } catch (_) {
        print(_);
        return null;
      }
    }
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
      String provider) async {
    if (provider == 'firebase.com') {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password ?? 'password',
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'first_name': firstName,
          'last_name': lastName,
          'born_date': bornDate,
          'gender': gender,
          'last_seen': Timestamp.now(),
          'reg_date': Timestamp.now(),
          'first_login': true,
          'avatar': gender == 'male'
              ? 'https://firebasestorage.googleapis.com/v0/b/natour21-desdiv.appspot.com/o/avatar%2Favatar-man.png?alt=media&token=ab95d643-8f94-45c5-a63e-6cf8f5e6efe1'
              : 'https://firebasestorage.googleapis.com/v0/b/natour21-desdiv.appspot.com/o/avatar%2Favatar-woman.png?alt=media&token=5d844380-62a7-4069-9b84-d71d08155748',
          'login_counter': 0
        });
        return 'true';
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "operation-not-allowed":
            return "Attenzione, non è stato possibile eseguire la richiesta, riprova.";

          case "weak-password":
            return "La password inserita è troppo corta. Minimo 8 caratteri";

          case "invalid-email":
            return "L'email inserita non è corretta";

          case "email-already-in-use":
            return "L'email inserita è già in uso per un altro account";

          case "invalid-credential":
            return "L'email inserita non è corretta";

          default:
            return "Attenzione, non è stato possibile eseguire la richiesta, riprova.";
        }
      }
    } else {
      try {
        await FirebaseFirestore.instance.collection('users').doc(userID).set({
          'first_name': firstName,
          'last_name': lastName,
          'born_date': bornDate,
          'gender': gender,
          'last_seen': Timestamp.now(),
          'reg_date': Timestamp.now(),
          'first_login': false,
          'avatar': avatar,
          'login_counter': 0
        });
        Global().myUser.value.setLastSeen = Timestamp.now().toDate();
        Global().myUser.value.setRegDate = Timestamp.now().toDate();
        Global().myUser.value.setFirstLogin = false;
        Global().myUser.value.setLoginCounter = 0;
        return 'true';
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          default:
            return "Attenzione, non è stato possibile eseguire la richiesta, riprova.";
        }
      }
    }
  }

  @override
  Future<bool> reauthenticateUser(String provider) async {
    AuthCredential _credential;
    if (provider == 'firebase.com') {
      _credential = EmailAuthProvider.credential(
          email: await Global().storage.read(key: 'email') ?? 'email@email.it',
          password: await Global().storage.read(key: 'password') ?? 'password');
    } else if (provider == 'facebook.com') {
      _credential = FacebookAuthProvider.credential(
          await Global().storage.read(key: 'tokenFacebook') ?? 'tokenFacebook');
    } else {
      _credential = GoogleAuthProvider.credential(
          accessToken:
              await Global().storage.read(key: 'accessToken') ?? 'accessToken',
          idToken: await Global().storage.read(key: 'idToken') ?? 'idToken');
    }

    try {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(_credential);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        Global().myUser.value = FireBaseUser.fromJson(value.data());
        Global().myUser.value.setLastSeen = (Timestamp.now()).toDate();
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'last_seen': Timestamp.now(),
        'login_counter': Global().myUser.value.loginCounter! + 1
      });

      Global().myUser.value.setId = FirebaseAuth.instance.currentUser!.uid;
      Global().myUser.value.setEmail =
          FirebaseAuth.instance.currentUser!.providerData[0].email!;
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> updatePassword(String password, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: (await Global().storage.read(key: 'email'))!,
        password: (await Global().storage.read(key: 'password'))!);

    await user!.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(password).then((_) {
        Navigator.of(context).pop();
        CustomAlertDialog(
            title: 'Congratulazioni',
            body: "La tua password è stata aggiornata con successo.",
            titleConfirmButton: 'Chiudi',
            onPressConfirm: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }).showCustomDialog(context);
      }).catchError((error) {
        Navigator.of(context).pop();
        CustomAlertDialog(
                title: 'Attenzione',
                body: "Non è stato possibile modificare la password.",
                titleConfirmButton: 'Chiudi',
                onPressConfirm: () =>
                    Navigator.of(Global().navigatorKey.currentContext!).pop())
            .showCustomDialog(context);
      });
    }).catchError((err) {});
  }

  @override
  Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return 'true';
    } on Exception catch (e) {
      if (e.toString().contains('user-not-found')) {
        return "L'email inserita non è associata a nessun account";
      } else if (e.toString().contains('invalid-email')) {
        return "L'email inserita non è corretta";
      } else {
        return "Attenzione, non è stato possibile eseguire la richiesta, riprova.";
      }
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await FacebookAuth.instance.logOut();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
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
