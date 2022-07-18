import 'package:natour21/Controller/token_notify_controller.dart';
import 'package:natour21/Dao_Class/Notify/one_signal.dart';

class NotifyController {
  NotifyController._privateConstructor();

  static final NotifyController _instance =
      NotifyController._privateConstructor();

  factory NotifyController() => _instance;

  Future<void> sendChatNotify(String title, String body, String userID) async {
    await OneSignal().sendChatNotify(
        title, body, await TokenNotifyController().getTokenList(userID));
  }
}
