import 'package:natour21/Dao_Class/SearchStatistics/postgres_statistics.dart';

class SearchStatisticsController {
  SearchStatisticsController._privateConstructor();

  static final SearchStatisticsController _instance =
      SearchStatisticsController._privateConstructor();

  factory SearchStatisticsController() => _instance;

  Future<void> getSearchStats() async =>
      await PostgresStatistics().getSearchStats();

  Future<void> addSearchStats(String keyword, List<int> itineraryVec) async =>
      await PostgresStatistics().addSearchStats(keyword, itineraryVec);
}
