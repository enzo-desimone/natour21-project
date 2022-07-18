
abstract class NotifyDao {
  Future<bool> sendChatNotify(String title, String body, String userToken);

}
