abstract class SearchStatisticsDao {
  Future<void> getSearchStats();
  Future<void> addSearchStats(String keyword, List<int> itineraryVec);
}
