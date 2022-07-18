import 'dart:io';
import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:natour21/Entity_Class/chat_entity/room_chat.dart';
import 'package:natour21/Entity_Class/fire_base_user.dart';
import 'package:natour21/Entity_Class/itinerary.dart';
import 'package:natour21/Entity_Class/search_statistics.dart';
import '../Entity_Class/cognito_admin.dart';
import 'onesignal_notify.dart';

class Global {
  //System
  late bool isEnablePermission;
  final howOS = Platform.operatingSystem;

  //App-System
  String provider = 'firebase.com';
  final storage = FlutterSecureStorage();
  final OneSignalNotify notify = OneSignalNotify();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  final platform = Platform.localeName[0] + Platform.localeName[1];
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  //Entity
  late Stream<List<RoomChat>> streamRoomChat;
  late Stream<FireBaseUser> streamUser;
  ValueNotifier<FireBaseUser> myUser = ValueNotifier(FireBaseUser());
  CognitoAdmin myAdmin = CognitoAdmin();
  Itinerary itinerary = Itinerary();
  ValueNotifier<List<Itinerary>> myItinerary = ValueNotifier([]);
  ValueNotifier<List<Itinerary>> allItinerary = ValueNotifier([]);
  ValueNotifier<List<Itinerary>> homeItinerary = ValueNotifier([]);
  ValueNotifier<List<Itinerary>> searchItinerary = ValueNotifier([]);
  ValueNotifier<List<SearchStatistics>> searchStats = ValueNotifier([]);

  final Random random = Random();

  Global._privateConstructor();

  static final Global _instance = Global._privateConstructor();

  factory Global() => _instance;

  get api => null;

  Future<void> sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
  }
}

String getRandomString(int length) {
  Random _rnd = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890@#*[]!£%&()';
  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

extension TrimExtension on String {
  String trimAll() => trimLeft().trimRight();
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';

  String get allInCaps => toUpperCase();

  String get capitalizeFirstOfEach =>
      split(" ").map((str) => str.capitalize()).join(" ");
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}

Future<bool> checkUrl() async {
  try {
    if (await InternetAddress.lookup('google.it')
        .then((value) => value.isNotEmpty && value[0].rawAddress.isNotEmpty)) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}
