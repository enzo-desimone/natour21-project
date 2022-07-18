class Review {
  int? _idReview;
  String? _title;
  String? _body;
  double? _star;
  int? _fkIdItinerary;
  String? _fkIdKey;

  Review({idReview, title, body, star, fkIdItinerary, fkIdKey}) {
    _idReview = idReview;
    _title = title;
    _body = body;
    _star = star;
    _fkIdItinerary = fkIdItinerary;
    _fkIdKey = fkIdKey;
  }

  factory Review.fromJson(dynamic json) {
    return Review(
      idReview: json['id_review'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      star: double.parse(json['star'] as String),
      fkIdItinerary: json['fk_id_itinerary'] as int,
      fkIdKey: json['fk_id_key'] as String,
    );
  }

  @override
  String toString() {
    return '{ $_idReview, $_title, $_body, $_star, $_fkIdItinerary, $_fkIdKey}';
  }

  String get fkIdKey => _fkIdKey!;

  void setFkIdKey(String value) {
    _fkIdKey = value;
  }

  int get fkIdItinerary => _fkIdItinerary!;

  void setFkIdItinerary(int value) {
    _fkIdItinerary = value;
  }

  double get star => _star!;

  void setStar(double value) {
    _star = value;
  }

  String get body => _body!;

  void setBody(String value) {
    _body = value;
  }

  String get title => _title!;

  void setTitle(String value) {
    _title = value;
  }

  int get idReview => _idReview!;

  void setIdReview(int value) {
    _idReview = value;
  }
}
