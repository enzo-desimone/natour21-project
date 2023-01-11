import 'package:natour21/Dao_Class/Notify/notify_dao.dart';
import '../../Accessory_Class/global_variable.dart';

class OneSignal implements NotifyDao {

  var _mock;


  OneSignal._privateConstructor();

  static final OneSignal _instance = OneSignal._privateConstructor();

  factory OneSignal({var mock}) {
    _instance._mock = mock;
    return _instance;
  }

  @override
  Future<bool> sendChatNotify(
      String title, String body, String userToken) async {
    if (userToken != await Global().notify.getPlayerId()) {
      return false;
    }

    var doc = (await _mock.collection('user_token').get())
                .docs
                ?.first
                .get('token') ==
            userToken
        ? userToken
        : (await _mock.collection('user_token').get()).docs.last.get('token') ==
                userToken
            ? userToken
            : '';

    if (doc.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
