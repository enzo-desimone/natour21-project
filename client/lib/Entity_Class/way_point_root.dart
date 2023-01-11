class WayPointRoot {
  int? _idWayPoint;
  double? _phi;
  double? _lambda;
  bool? _isStart;
  bool? _isEnd;
  int? _fkIdItinerary;

  WayPointRoot({idWayPoint, phi, lambda, isStart, isEnd, fkIdItinerary}) {
    _idWayPoint = idWayPoint;
    _phi = phi;
    _lambda = lambda;
    _isStart = isStart;
    _isEnd = isEnd;
    _fkIdItinerary = fkIdItinerary;
  }

  factory WayPointRoot.fromJson(dynamic json) {
    return WayPointRoot(
        idWayPoint: json['id_way_point_route'] as int?,
        phi: double.parse(json['phi'] as String),
        lambda: double.parse(json['lambda'] as String),
        isStart: json['is_start'] as bool?,
        isEnd: json['is_end'] as bool?,
        fkIdItinerary: json['fk_id_itinerary'] as int?);
  }

  @override
  String toString() {
    return '{ "id_way_point" : $_idWayPoint, "phi" : $_phi, "lambda" : $_lambda, "is_start" : $_isStart, "is_end" : $_isEnd, "fk_id_itinerary" : $_fkIdItinerary}';
  }

  bool get isEnd => _isEnd!;

  void setIsEnd(bool value) {
    _isEnd = value;
  }

  bool get isStart => _isStart!;

  void setIsStart(bool value) {
    _isStart = value;
  }

  double get lambda => _lambda!;

  void setLambda(double value) {
    _lambda = value;
  }

  double get phi => _phi!;

  void setPhi(double value) {
    _phi = value;
  }

  int get idWayPoint => _idWayPoint!;

  void setIdWayPoint(int value) {
    _idWayPoint = value;
  }

  int get fkIdItinerary => _fkIdItinerary!;

  void setFkIdItinerary(int value) {
    _fkIdItinerary = value;
  }
}
