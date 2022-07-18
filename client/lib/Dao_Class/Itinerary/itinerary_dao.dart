
abstract class ItineraryDao {
  Future<bool> addItinerary();
  Future<bool> editItinerary();
  Future<bool> deleteItinerary(int itineraryId);
  Future<void> getMyItinerary();
  Future<void> getItinerary();
}
