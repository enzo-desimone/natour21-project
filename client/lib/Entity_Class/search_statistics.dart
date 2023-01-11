import 'itinerary.dart';

class SearchStatistics {
  int? _idSearchStatistics;
  String? _keyword;
  int? _statsCount;
  List<Itinerary>? _itineraryList;

  SearchStatistics({idSearchStatistics, keyword, statsCount, itineraryList}) {
    _idSearchStatistics = idSearchStatistics;
    _keyword = keyword;
    _statsCount = statsCount;
    _itineraryList = itineraryList;
  }

  factory SearchStatistics.fromJson(dynamic json) {
    return SearchStatistics(
        idSearchStatistics: json['id_search_statistics'] as int?,
        keyword: json['keyword'] as String?,
        statsCount: json['stats_count'] as int?,
        itineraryList: (json['itinerary']['records'] as List)
            .map((data) => Itinerary.fromJsonSearch(data))
            .toList());
  }

  @override
  String toString() {
    return '{ $_idSearchStatistics, $_keyword, $_statsCount, $_itineraryList}';
  }

  int? get idSearchStatistics => _idSearchStatistics;

  set setIdSearchStatistics(int value) {
    _idSearchStatistics = value;
  }

  String? get keyword => _keyword;

  set setKeyWord(String value) {
    _keyword = value;
  }

  int? get statsCount => _statsCount;

  set setStatsCount(int value) {
    _statsCount = value;
  }

  List<Itinerary>? get itineraryList => _itineraryList;

  set setItineraryList(List<Itinerary> value) {
    _itineraryList = value;
  }
}
