import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:natour21/Accessory_Class/one_signal.dart';

class OneSignalTest {
  Future<void> sendChatNotify_1_2(FakeFirebaseFirestore mock) async {
    var result = await OneSignal().sendChatNotify('title', 'body', 'example');
    assert(result == false);
  }

  Future<void> sendChatNotify_1_3_4_5(FakeFirebaseFirestore mock) async {
    await mock.collection('user_token').add({'token': '43tqgwrfav3'});
    var result =
        await OneSignal().sendChatNotify('title', 'body', '9rrWD2K5Kr');
    assert(result == false);
  }

  Future<void> sendChatNotify_1_3_4_6(FakeFirebaseFirestore mock) async {
    await mock.collection('user_token').add({'token': '9rrWD2K5Kr'});
    var result =
        await OneSignal().sendChatNotify('title', 'body', '9rrWD2K5Kr');
    assert(result == true);
  }
}
