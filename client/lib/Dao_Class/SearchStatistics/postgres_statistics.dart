import 'dart:convert';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:http/http.dart' as http;
import 'package:natour21/Dao_Class/SearchStatistics/search_statistics_dao.dart';
import 'package:natour21/Entity_Class/search_statistics.dart';

class PostgresStatistics implements SearchStatisticsDao {
  final String _username = 'raF3pBHgw6HB26Cz24Jg9V4mbFdSTTT9';
  final String _url = 'https://natour21.besimsoft.com/uq6PMpSfiZ/api/';
  final String _password = 'NMftBBs2Mm6VPAxL4ZxtFXXyntYug26R';
  String _basicAuth = '';

  PostgresStatistics._privateConstructor() {
    _basicAuth = 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
  }

  static final PostgresStatistics _instance =
      PostgresStatistics._privateConstructor();

  factory PostgresStatistics() => _instance;

  @override
  Future<void> getSearchStats() async {
    try {
      final _result = await http.post(
        Uri.parse(_url + 'search_statistics/get'),
        headers: <String, String>{'authorization': _basicAuth},
        body: {
          'is_admin': Global().myUser.value.id ?? 'true',
          'id_key': Global().myUser.value.id ?? '',
          'jwt': (await Global().storage.read(key: 'tokenAuth'))!
        },
        encoding: Encoding.getByName("UTF-8"),
      );
      if (_result.statusCode == 200) {
        Global().searchStats.value =
            (json.decode(_result.body)['records'] as List)
                .map((data) => SearchStatistics.fromJson(data))
                .toList();
      } else {
        Global().searchStats.value = [];
      }
    } catch (e) {
      //
    }
  }

  @override
  Future<void> addSearchStats(String keyword, List<int> itineraryVec) async {
    try {
      await http.post(
        Uri.parse(_url + 'search_statistics/add'),
        headers: <String, String>{'authorization': _basicAuth},
        body: {
          'keyword': keyword.trimAll().toLowerCase(),
          'itinerary_ids': itineraryVec.toString(),
          'is_admin': Global().myUser.value.id ?? 'true',
          'id_key': Global().myUser.value.id ?? '',
          'jwt': (await Global().storage.read(key: 'tokenAuth'))!
        },
        encoding: Encoding.getByName("UTF-8"),
      );
    } catch (e) {
      //
    }
  }
}
