import 'package:natour21/Entity_Class/interest_point.dart';
import 'package:natour21/Entity_Class/review.dart';
import 'package:natour21/Entity_Class/way_point_root.dart';

class Itinerary {
  int? _idItinerary;
  String? _name;
  int? _deltaTime;
  double? _distance;
  String? _description;
  int? _level;
  int? _category;
  String? _fkIdKey;
  List<WayPointRoot>? _route = [];
  List<InterestPoint>? _interestPoint = [];
  List<Review>? _reviews = [];

  Itinerary(
      {idItinerary,
      name,
      deltaTime,
      distance,
      description,
      level,
      category,
      fkIdKey,
      route,
      interestPoint,
      reviews}) {
    _idItinerary = idItinerary;
    _name = name;
    _deltaTime = deltaTime;
    _distance = distance ?? 0;
    _description = description;
    _level = level;
    _category = category;
    _fkIdKey = fkIdKey;
    _route = route ?? [];
    _interestPoint = interestPoint ?? [];
    _reviews = reviews ?? [];
  }

  factory Itinerary.fromJson(dynamic json) {
    return Itinerary(
        idItinerary: json['id_itinerary'] as int?,
        name: json['name'] as String?,
        deltaTime: json['delta_time'] as int?,
        distance: double.parse(json['distance'] as String),
        description: json['description'] as String,
        level: int.parse(json['level'] as String),
        category: int.parse(json['category'] as String),
        fkIdKey: json['fk_id_key'] as String?,
        route: (json['route']['records'] as List)
            .map((data) => WayPointRoot.fromJson(data))
            .toList(),
        interestPoint: (json['interest_point']['records'] as List)
            .map((data) => InterestPoint.fromJson(data))
            .toList(),
        reviews: (json['reviews']['records'] as List)
            .map((data) => Review.fromJson(data))
            .toList());
  }

  factory Itinerary.fromJsonSearch(dynamic json) {
    return Itinerary(
      idItinerary: json['id_itinerary'] as int?,
      name: json['title'] as String?,
      fkIdKey: json['fk_id_key'] as String?,
    );
  }

  @override
  String toString() {
    return '{ $_idItinerary, $_name, $_deltaTime, $_distance, $_description, $_level, $_category, $_route, $_interestPoint, $_reviews}';
  }

  List<Review>? get reviews => _reviews;

  void setReviews(List<Review> value) {
    _reviews = value;
  }

  List<InterestPoint>? get interestPoint => _interestPoint;

  void setInterestPoint(List<InterestPoint> value) {
    _interestPoint = value;
  }

  List<WayPointRoot>? get route => _route;

  void setRoute(List<WayPointRoot> value) {
    _route = value;
  }

  int? get category => _category;

  void setCategory(int value) {
    _category = value;
  }

  int? get level => _level;

  void setLevel(int value) {
    _level = value;
  }

  String? get description => _description;

  void setDescription(String value) {
    _description = value;
  }

  int? get deltaTime => _deltaTime;

  void setTime(int value) {
    _deltaTime = value;
  }

  double? get distance => _distance;

  void setDistance(double value) {
    _distance = value;
  }

  String? get name => _name;

  void setName(String value) {
    _name = value;
  }

  int? get idItinerary => _idItinerary;

  void setIdItinerary(int value) {
    _idItinerary = value;
  }

  String? get fkIdKey => _fkIdKey;

  void setFkIdKey(String value) {
    _fkIdKey = value;
  }

  String getLevelTitle(int index) {
    if (index == 1) {
      return 'Semplice';
    } else if (index == 2) {
      return 'Moderato';
    } else if (index == 3) {
      return 'Difficile';
    } else {
      return 'Estremo';
    }
  }

  int getLevel(String title) {
    if (title == 'Semplice') {
      return 1;
    } else if (title == 'Moderato') {
      return 2;
    } else if (title == 'Difficile') {
      return 3;
    } else {
      return 4;
    }
  }

  static String convertMsToHuman(int ms, {int decimals = 1}) {
    int h, m;
    m = (ms / 1000 / 60).floor();
    h = (m / 60).floor();
    m = m % 60;
    if (h == 0) {
      return '${m.toString()}m';
    } else {
      return '${h.toString()}h ${m.toString()}m';
    }
  }
}
