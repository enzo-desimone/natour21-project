import 'package:flutter_test/flutter_test.dart';
import 'firestore_user_test.dart';
import 'itinerary_controller_test.dart';
import 'one_signal_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final instance = FakeFirebaseFirestore();
  await instance.collection('users').add({
    'username': 'andrea',
  });

  test('Test import null gpx file', () async {
    await ItineraryControllerTest().importGpxFileCE1();
  });
  test('Test import wrong format gpx file', () async {
    await ItineraryControllerTest().importGpxFileCE2();
  });
  test('Test import no waypoint gpx file', () async {
    await ItineraryControllerTest().importGpxFileCE3();
  });
  test('Test import correct gpx file', () async {
    await ItineraryControllerTest().importGpxFileCE4();
  });
  test('Test null user and null image', () async {
    await FireStoreUserTest().updateAvatarCE1(instance);
  });
  test('Test null user and exist image', () async {
    await FireStoreUserTest().updateAvatarCE2(instance);
  });
  test('Test not exist user and null image', () async {
    await FireStoreUserTest().updateAvatarCE3(instance);
  });
  test('Test not exist user and exist image', () async {
    await FireStoreUserTest().updateAvatarCE4(instance);
  });
  test('Test exist user and null image', () async {
    await FireStoreUserTest().updateAvatarCE5(instance);
  });
  test('Test exist user and exist image', () async {
    await FireStoreUserTest().updateAvatarCE6(instance);
  });
  test('Test wrong system user token', () async {
    await OneSignalTest().sendChatNotify_1_2(instance);
  });
  test('Test correct system token but not exist into database', () async {
    await OneSignalTest().sendChatNotify_1_3_4_5(instance);
  });
  test('Test correct system token and exist into database', () async {
    await OneSignalTest().sendChatNotify_1_3_4_6(instance);
  });
}
