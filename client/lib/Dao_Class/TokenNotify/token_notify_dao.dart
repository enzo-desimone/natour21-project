
abstract class TokenNotifyDao {
  Future<bool> addToken(String idKey, String idTokenNotify);

  Future<bool> deleteToken(String idTokenNotify);

  Future<String> getTokenList(String userID);
}
