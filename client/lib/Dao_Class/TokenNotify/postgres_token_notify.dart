import 'dart:convert';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Dao_Class/TokenNotify/token_notify_dao.dart';
import 'package:http/http.dart' as http;
import 'package:natour21/Entity_Class/token_notify.dart';

class PostgresTokenNotify implements TokenNotifyDao {
  final String _username = 'raF3pBHgw6HB26Cz24Jg9V4mbFdSTTT9';
  final String _url = 'https://besimsoft.com/.natour21/uq6PMpSfiZ/api/';
  final String _password = 'NMftBBs2Mm6VPAxL4ZxtFXXyntYug26R';
  String _basicAuth = '';

  PostgresTokenNotify._privateConstructor() {
    _basicAuth = 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
  }

  static final PostgresTokenNotify _instance =
      PostgresTokenNotify._privateConstructor();

  factory PostgresTokenNotify() => _instance;

  @override
  Future<bool> addToken(String idKey, String idTokenNotify) async {
    try {
      final result = await http.post(
        Uri.parse(_url + 'token_notify/add'),
        headers: <String, String>{'authorization': _basicAuth},
        body: {
          'id_token_notify': idTokenNotify.trimAll(),
          'fk_id_key': idKey.trimAll(),
          'is_admin': Global().myUser.value.id ?? 'true',
          'id_key': Global().myUser.value.id ?? '',
          'jwt': (await Global().storage.read(key: 'tokenAuth'))!
        },
        encoding: Encoding.getByName("UTF-8"),
      );
      if (result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteToken(String idTokenNotify) async {
    try {
      final result = await http.post(
        Uri.parse(_url + 'token_notify/delete'),
        headers: <String, String>{'authorization': _basicAuth},
        body: {
          'id_token_notify': idTokenNotify.trimAll(),
          'is_admin': Global().myUser.value.id ?? 'true',
          'id_key': Global().myUser.value.id ?? '',
          'jwt': (await Global().storage.read(key: 'tokenAuth'))!
        },
        encoding: Encoding.getByName("UTF-8"),
      );
      if (result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> getTokenList(String userID) async {
    try {
      final response = await http.post(
        Uri.parse(_url + 'token_notify/get_list'),
        headers: <String, String>{'authorization': _basicAuth},
        body: <String, String>{
          'fk_id_key': userID,
          'is_admin': Global().myUser.value.id ?? 'true',
          'id_key': Global().myUser.value.id ?? '',
          'jwt': (await Global().storage.read(key: 'tokenAuth'))!
        },
      );
      if (response.statusCode == 200) {
        final _tokenList = (json.decode(response.body)['records'] as List)
            .map((data) => TokenNotify.fromJson(data))
            .toList();

        String tempToken = '';

        if (_tokenList.isNotEmpty) {
          tempToken = "[";
          for (int i = 0; i < _tokenList.length; i++) {
            if (_tokenList.length > 1 && i != _tokenList.length - 1) {
              tempToken += '"' + _tokenList[i].idTokenNotify! + '"' + ",";
            } else if (_tokenList.length > 1 && i == _tokenList.length - 1) {
              tempToken += '"' + _tokenList[i].idTokenNotify! + '"' + "]";
            } else {
              tempToken += '"' + _tokenList[i].idTokenNotify! + '"' + "]";
            }
          }
        }
        return tempToken;
      } else {
        return '';
      }
    } on Exception catch (_) {
      return '';
    }
  }
}
