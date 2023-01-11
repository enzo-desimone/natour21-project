import 'dart:convert';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Dao_Class/Itinerary/itinerary_dao.dart';
import 'package:http/http.dart' as http;
import 'package:natour21/Entity_Class/itinerary.dart';

class PostgresItinerary implements ItineraryDao {
  final String _username = 'raF3pBHgw6HB26Cz24Jg9V4mbFdSTTT9';
  final String _url = 'https://natour21.besimsoft.com/uq6PMpSfiZ/api/';
  final String _password = 'NMftBBs2Mm6VPAxL4ZxtFXXyntYug26R';
  String _basicAuth = '';

  PostgresItinerary._privateConstructor() {
    _basicAuth = 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
  }

  static final PostgresItinerary _instance =
      PostgresItinerary._privateConstructor();

  factory PostgresItinerary() => _instance;

  @override
  Future<void> getItinerary() async {
    try {
      final _result = await http.post(
        Uri.parse(_url + 'itinerary/get'),
        headers: <String, String>{'authorization': _basicAuth},
        body: {
          'is_admin': Global().myUser.value.id ?? 'true',
          'id_key': Global().myUser.value.id ?? '',
          'jwt': (await Global().storage.read(key: 'tokenAuth'))!
        },
        encoding: Encoding.getByName("UTF-8"),
      );
      if (_result.statusCode == 200) {
        Global().allItinerary.value =
            (json.decode(_result.body)['records'] as List)
                .map((data) => Itinerary.fromJson(data))
                .toList();
        Global().homeItinerary.value = Global().allItinerary.value;
        Global().searchItinerary.value = Global().allItinerary.value;
      } else {
        Global().allItinerary.value = [];
        Global().homeItinerary.value = Global().allItinerary.value;
        Global().searchItinerary.value = Global().allItinerary.value;
      }
    } catch (e) {
      //
    }
  }

  @override
  Future<void> getMyItinerary() async {
    try {
      final _result = await http.post(
        Uri.parse(_url + 'itinerary/user_get'),
        headers: <String, String>{'authorization': _basicAuth},
        body: {
          'fk_id_key': Global().myUser.value.id,
          'is_admin': Global().myUser.value.id ?? 'true',
          'id_key': Global().myUser.value.id ?? '',
          'jwt': (await Global().storage.read(key: 'tokenAuth'))!
        },
        encoding: Encoding.getByName("UTF-8"),
      );
      if (_result.statusCode == 200) {
        Global().myItinerary.value =
            (json.decode(_result.body)['records'] as List)
                .map((data) => Itinerary.fromJson(data))
                .toList();
      } else {
        Global().myItinerary.value = [];
      }
    } catch (e) {
      //
    }
  }

  @override
  Future<bool> addItinerary() async {
    try {
      final _result = await http.post(
        Uri.parse(_url + 'itinerary/add'),
        headers: <String, String>{'authorization': _basicAuth},
        body: {
          'name': Global().itinerary.name!.trimAll().toLowerCase(),
          'delta_time': Global().itinerary.deltaTime.toString(),
          'distance': Global().itinerary.distance?.toStringAsExponential(2),
          'category': Global().itinerary.category.toString(),
          'level': Global().itinerary.level.toString(),
          'description': Global().itinerary.description ?? '',
          'fk_id_key': Global().myUser.value.id,
          'route': Global().itinerary.route.toString(),
          'interest_point': Global().itinerary.interestPoint.toString(),
          'is_admin': Global().myUser.value.id ?? 'true',
          'id_key': Global().myUser.value.id ?? '',
          'jwt': (await Global().storage.read(key: 'tokenAuth'))!
        },
        encoding: Encoding.getByName("UTF-8"),
      );
      if (_result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> editItinerary() async {
    try {
      final _result = await http.post(
        Uri.parse(_url + 'itinerary/edit'),
        headers: <String, String>{'authorization': _basicAuth},
        body: {
          'id': Global().itinerary.idItinerary.toString(),
          'name': Global().itinerary.name!.trimAll().toLowerCase(),
          'delta_time': Global().itinerary.deltaTime.toString(),
          'distance': Global().itinerary.distance?.toStringAsExponential(2),
          'category': Global().itinerary.category.toString(),
          'level': Global().itinerary.level.toString(),
          'description': Global().itinerary.description ?? '',
          'fk_id_key': Global().myUser.value.id,
          'route': Global().itinerary.route.toString(),
          'interest_point': Global().itinerary.interestPoint.toString(),
          'is_admin': Global().myUser.value.id ?? 'true',
          'id_key': Global().myUser.value.id ?? '',
          'jwt': (await Global().storage.read(key: 'tokenAuth'))!
        },
        encoding: Encoding.getByName("UTF-8"),
      );
      if (_result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> deleteItinerary(int itineraryId) async {
    try {
      final _result = await http.post(
        Uri.parse(_url + 'itinerary/delete'),
        headers: <String, String>{'authorization': _basicAuth},
        body: {
          'id_itinerary': itineraryId.toString(),
          'is_admin': Global().myUser.value.id ?? 'true',
          'id_key': Global().myUser.value.id ?? '',
          'jwt': (await Global().storage.read(key: 'tokenAuth'))!
        },
        encoding: Encoding.getByName("UTF-8"),
      );
      if (_result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
