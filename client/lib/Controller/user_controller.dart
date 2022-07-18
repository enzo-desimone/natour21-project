import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_GUI/custom_dialog.dart';
import 'package:natour21/Admin_Tab_GUI/admin_home_tab.dart';
import 'package:natour21/Admin_Tab_GUI/main_tab_admin.dart';
import 'package:natour21/Controller/room_controller.dart';
import 'package:natour21/Controller/search_statistics_controller.dart';
import 'package:natour21/Controller/token_notify_controller.dart';
import 'package:natour21/Dao_Class/User-Admin/cognito_oauth.dart';
import 'package:natour21/Dao_Class/User-Admin/firebase_oauth.dart';
import 'package:natour21/Dao_Class/User-Admin/firestore_user.dart';
import 'package:natour21/Dao_Class/User-Admin/postgres_user.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';
import 'package:provider/provider.dart';
import '../Account_GUI/login_signup/welcome_pages/welcome_gui.dart';
import '../Client_Tab_GUI/main_tab.dart';
import 'itinerary_controller.dart';

class UserController {
  UserController._privateConstructor();

  static final UserController _instance = UserController._privateConstructor();

  factory UserController() => _instance;

  Future<void> login(
      String email, String password, BuildContext context) async {
    CustomAlertDialog.loadingScreen(context, null);
    if ((RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email.toLowerCase()))) {
      String _returnLogin =
          await FirebaseOauth().loginWithEmail(email, password);
      if (_returnLogin == 'true') {
        await ItineraryController().getItinerary();
        await ItineraryController().getMyItinerary();
        await Global().storage.write(
            key: 'tokenAuth',
            value: await FirebaseAuth.instance.currentUser!.getIdToken());
        Global().streamRoomChat = RoomController().getRooms();
        Global().streamUser = UserController().getStreamUser();
        Global().provider = 'firebase.com';
        if (Global().myUser.value.firstLogin == true) {
          await PostgresUser().signUpPostgres(Global().myUser.value.id!);
        }
        await TokenNotifyController().addToken(
            Global().myUser.value.id!, await Global().notify.getPlayerId());
        Navigator.pop(context);
        if (Global().myUser.value.firstLogin!) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const WelcomePage(
                provider: 'firebase.com',
              ),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainTab(),
            ),
          );
        }
      } else {
        Navigator.pop(context);
        CustomAlertDialog(
                title: 'Errore',
                body: _returnLogin,
                titleConfirmButton: 'Chiudi',
                onPressConfirm: () => Navigator.of(context).pop())
            .showCustomDialog(context);
      }
    } else {
      String _returnLogin =
          await CognitoOauth().loginWithEmail(email, password);
      if (_returnLogin == 'true') {
        await SearchStatisticsController().getSearchStats();
        await context.read<ItineraryCategory>().reloadItinerary();
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainTabAdmin(),
          ),
        );
      } else {
        Navigator.pop(context);
        CustomAlertDialog(
                title: 'Errore',
                body: _returnLogin,
                titleConfirmButton: 'Chiudi',
                onPressConfirm: () => Navigator.of(context).pop())
            .showCustomDialog(context);
      }
    }
  }

  Future<void> loginWithSocial(
      String oauthProvider, BuildContext context) async {
    if (oauthProvider == 'facebook.com') {
      CustomAlertDialog.loadingScreen(
         context, Colors.blue[600]);
    } else {
      CustomAlertDialog.loadingScreen(context, Colors.red[600]);
    }

    final _fireBaseUser = await FirebaseOauth().loginWithSocial(oauthProvider);

    if (_fireBaseUser != null) {
      Global().streamRoomChat = RoomController().getRooms();
      Global().streamUser = UserController().getStreamUser();
      await Global().storage.write(
          key: 'tokenAuth',
          value: await FirebaseAuth.instance.currentUser!.getIdToken());
      if (oauthProvider == 'facebook.com') {
        Global().myUser.value.setId = _fireBaseUser.user!.uid;
        Global().provider = 'facebook.com';
      }
      if (oauthProvider == 'google.com') {
        String _fullName = FirebaseAuth.instance.currentUser!.displayName!;
        String _name = '';
        int index = _fullName.indexOf(" ");
        if (index > -1) {
          _name = _fullName.substring(0, index);
        }
        String _surname = _fullName.replaceAll(_name, '');
        Global().provider = 'google.com';

        Global().myUser.value.setFirstName = _name.trimAll();
        Global().myUser.value.setLastName = _surname.trimAll();
        Global().myUser.value.setEmail =
            FirebaseAuth.instance.currentUser!.providerData[0].email!;
        Global().myUser.value.setAvatar = FirebaseAuth
            .instance.currentUser!.photoURL!
            .replaceAll('s96-c', 's496-c');
        Global().myUser.value.setId = FirebaseAuth.instance.currentUser!.uid;
      }

      await ItineraryController().getItinerary();
      await ItineraryController().getMyItinerary();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_fireBaseUser.user!.uid)
          .get()
          .then((value) async {
        await TokenNotifyController().addToken(
            Global().myUser.value.id!, await Global().notify.getPlayerId());
        if (!value.exists) {
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const WelcomePage(
                provider: 'facebook.com',
              ),
            ),
          );
        } else {
          var data = value.data() as Map<String, dynamic>;
          Global().myUser.value.setGender = data['gender'];
          Global().myUser.value.setBornDate = data['born_date'];
          Global().myUser.value.setFirstLogin = data['first_login'];
          Global().myUser.value.setLastSeen = (Timestamp.now()).toDate();
          Global().myUser.value.setRegDate = data['reg_date'].toDate();
          Global().myUser.value.setLoginCounter = data['login_counter'] + 1;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'last_seen': Timestamp.now(),
            'login_counter': data['login_counter'] + 1,
          });

          if (data['first_login']) {
            await PostgresUser().signUpPostgres(Global().myUser.value.id!);
          }
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainTab(),
            ),
          );
        }
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> signUpFireBaseUser(
      String firstName,
      String lastName,
      String bornDate,
      String gender,
      String email,
      String password,
      BuildContext context) async {
    CustomAlertDialog.loadingScreen(context, null);
    String _returnSignUp = await FirebaseOauth().signUpFireBaseUser(
        firstName,
        lastName,
        bornDate,
        gender,
        email,
        password,
        null,
        null,
        'firebase.com');
    Navigator.pop(context);
    if (_returnSignUp == 'true') {
      Navigator.pop(context);
      CustomAlertDialog(
          title: 'Congratulazioni',
          body: 'Registrazione, avvenuta con successo.',
          titleConfirmButton: 'Chiudi',
          onPressConfirm: () {
            Navigator.of(Global().navigatorKey.currentContext!).pop();
          }).showCustomDialog(context);
    } else {
      CustomAlertDialog(
              title: 'Errore',
              body: _returnSignUp,
              titleConfirmButton: 'Chiudi',
              onPressConfirm: () =>
                  Navigator.of(Global().navigatorKey.currentContext!).pop())
          .showCustomDialog(context);
    }
  }

  Future<void> signUpUserWithSocial(
      String bornDate, String gender, BuildContext context) async {
    CustomAlertDialog.loadingScreen(context, null);
    String _returnSignUp = await FirebaseOauth().signUpFireBaseUser(
        Global().myUser.value.firstName!,
        Global().myUser.value.lastName!,
        bornDate,
        gender,
        Global().myUser.value.email!,
        null,
        Global().myUser.value.avatar!,
        Global().myUser.value.id!,
        'social.com');
    if (_returnSignUp != 'true') {
      Navigator.pop(context);
      CustomAlertDialog(
              title: 'Errore',
              body: _returnSignUp,
              titleConfirmButton: 'Chiudi',
              onPressConfirm: () => Navigator.of(context).pop())
          .showCustomDialog(context);
    } else {
      await PostgresUser().signUpPostgres(Global().myUser.value.id!);
      await TokenNotifyController().addToken(
          Global().myUser.value.id!, await Global().notify.getPlayerId());
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainTab(),
        ),
      );
    }
  }

  Future<bool> reauthenticateUser(String provider) async {
    if (provider == 'facebook.com') {
      if (await FirebaseOauth().reauthenticateUser('facebook.com')) {
        await Global().storage.write(
            key: 'tokenAuth',
            value: await FirebaseAuth.instance.currentUser!.getIdToken());
        Global().streamRoomChat = RoomController().getRooms();
        Global().streamUser = UserController().getStreamUser();
        await ItineraryController().getItinerary();
        await ItineraryController().getMyItinerary();
        return true;
      } else {
        return false;
      }
    } else if (provider == 'google.com') {
      if (await FirebaseOauth().reauthenticateUser('google.com')) {
        await Global().storage.write(
            key: 'tokenAuth',
            value: await FirebaseAuth.instance.currentUser!.getIdToken());
        Global().streamRoomChat = RoomController().getRooms();
        Global().streamUser = UserController().getStreamUser();
        await ItineraryController().getItinerary();
        await ItineraryController().getMyItinerary();
        return true;
      } else {
        return false;
      }
    } else if (provider == 'firebase.com') {
      if (await FirebaseOauth().reauthenticateUser('firebase.com')) {
        await Global().storage.write(
            key: 'tokenAuth',
            value: await FirebaseAuth.instance.currentUser!.getIdToken());
        Global().streamRoomChat = RoomController().getRooms();
        Global().streamUser = UserController().getStreamUser();
        await ItineraryController().getItinerary();
        await ItineraryController().getMyItinerary();
        return true;
      } else {
        return false;
      }
    } else {
      if (await CognitoOauth().loginWithEmail(
              await Global().storage.read(key: 'email') ?? '',
              await Global().storage.read(key: 'password') ?? '') ==
          'true') {
        await SearchStatisticsController().getSearchStats();
        await Global()
            .navigatorKey
            .currentContext!
            .read<ItineraryCategory>()
            .reloadItinerary();
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> updatePassword(String password, BuildContext context) async {
    CustomAlertDialog.loadingScreen(context, null);
    await FirebaseOauth().updatePassword(password, context);
  }

  Future<void> resetPasswordUser(String email, BuildContext context) async {
    String _returnOauth = await FirebaseOauth().resetPassword(email);
    Navigator.of(context).pop();
    if (_returnOauth == 'true') {
      CustomAlertDialog(
          title: 'Congratulazioni',
          body:
              "Controlla la tua casella di posta elettronica per resettare la password",
          titleConfirmButton: 'Chiudi',
          onPressConfirm: () =>
              Navigator.of(Global().navigatorKey.currentContext!)
                  .pop()).showCustomDialog(context);
    } else {
      CustomAlertDialog(
              title: 'Errore',
              body: _returnOauth,
              titleConfirmButton: 'Chiudi',
              onPressConfirm: () =>
                  Navigator.of(Global().navigatorKey.currentContext!).pop())
          .showCustomDialog(context);
    }
  }

  Future<void> updateAvatar(File? avatarFile, BuildContext context) async {
    CustomAlertDialog.loadingScreen(context, null);
    await FireStoreUser().updateAvatar(Global().myUser.value.id!, avatarFile);
    Navigator.of(context).pop();
    if (context.widget.toString() != 'EditProfilePage') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainTab(),
        ),
      );
    }
  }

  Future<void> updateUser(
      String userID,
      String firstName,
      String lastName,
      String bornDate,
      String gender,
      String? email,
      BuildContext context) async {
    CustomAlertDialog.loadingScreen(context, null);
    await FireStoreUser().updateUser(
        userID,
        firstName.trimAll().toLowerCase(),
        lastName.trimAll().toLowerCase(),
        bornDate.trimAll().toLowerCase(),
        gender,
        email?.trimAll().toLowerCase());
    Navigator.pop(Global().navigatorKey.currentContext!);
    await Global.analytics.logEvent(
      name: 'edit_profile_event',
      parameters: <String, dynamic>{
        'user': Global().myUser.value.id,
      },
    );
  }

  Future<void> updateFirstLogin(BuildContext context) async {
    CustomAlertDialog.loadingScreen(context, null);
    await FireStoreUser().updateFirstLogin(Global().myUser.value.id!);
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainTab(),
      ),
    );
  }

  Future<bool> logOutUser(BuildContext context, String? provider) async {
    if (provider == null) {
      if (await FirebaseOauth().logout() && await CognitoOauth().logout()) {
        await TokenNotifyController()
            .deleteToken(await Global().notify.getPlayerId());
        return true;
      } else {
        CustomAlertDialog(
            title: 'Errore',
            body: 'Non è stato possibile uscire dal suo account',
            titleConfirmButton: 'Chiudi',
            onPressConfirm: () {
              Navigator.of(Global().navigatorKey.currentContext!).pop();
            }).showCustomDialog(context);
        return false;
      }
    } else {
      if (await CognitoOauth().logout()) {
        return true;
      } else {
        CustomAlertDialog(
                title: 'Errore',
                body: 'Non è stato possibile uscire dal suo account',
                titleConfirmButton: 'Chiudi',
                onPressConfirm: () => Navigator.of(context).pop())
            .showCustomDialog(context);
        return false;
      }
    }
  }

  Future<FireBaseUser> getUser(String userId) async {
    return await FireStoreUser().getUser(userId);
  }

  Stream<FireBaseUser> getStreamUser() {
    return FireStoreUser().getStreamUser();
  }

  Stream<List<FireBaseUser>> getUserList() {
    return FireStoreUser().getUserList();
  }
}
