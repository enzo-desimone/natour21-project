import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:natour21/Dao_Class/Notify/notify_dao.dart';

import '../../Accessory_Class/global_variable.dart';

class OneSignal implements NotifyDao {
  final String _username = 'raF3pBHgw6HB26Cz24Jg9V4mbFdSTTT9';
  final String _url = 'https://natour21.besimsoft.com/uq6PMpSfiZ/api/';
  final String _password = 'NMftBBs2Mm6VPAxL4ZxtFXXyntYug26R';
  var _mock;
  String _basicAuth = '';

  OneSignal._privateConstructor() {
    _basicAuth = 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
  }

  static final OneSignal _instance = OneSignal._privateConstructor();

  factory OneSignal({var mock}) {
    _instance._mock = mock;
    return _instance;
  }

  @override
  Future<bool> sendChatNotify(
      String title, String body, String userToken) async {
    try {
      await http.post(
        Uri.parse(_url + 'one_signal_notify/send_chat_notify'),
        headers: <String, String>{'authorization': _basicAuth},
        body: {
          'title': title,
          'body': body,
          'user_token': userToken,
          'id_key': Global().myUser.value.id
        },
      );
      return true;
    } on Exception catch (e) {
      print("AAAAAAAAAAAAAAAAAAAA: " + e.toString());
      return false;
    }
  }
}
