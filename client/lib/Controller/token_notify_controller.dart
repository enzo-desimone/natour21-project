import 'package:natour21/Dao_Class/TokenNotify/postgres_token_notify.dart';

class TokenNotifyController {
  TokenNotifyController._privateConstructor();

  static final TokenNotifyController _instance =
      TokenNotifyController._privateConstructor();

  factory TokenNotifyController() => _instance;

  Future<void> addToken(String idKey, String idTokenNotify) async {
    await PostgresTokenNotify().addToken(idKey, idTokenNotify);
  }

  Future<void> deleteToken(String idTokenNotify) async {
    await PostgresTokenNotify().deleteToken(idTokenNotify);
  }

  Future<String> getTokenList(String userID) async {
    return await PostgresTokenNotify().getTokenList(userID);
  }
}
