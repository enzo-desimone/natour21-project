class InterestPoint {
  int? _idInterestPoint;
  int? _typology;
  double? _phi;
  double? _lambda;
  int? _fkIdItinerary;

  InterestPoint({idInterestPoint, typology, phi, lambda, fkIdItinerary}) {
    _idInterestPoint = idInterestPoint;
    _typology = typology;
    _phi = phi;
    _lambda = lambda;
    _fkIdItinerary = fkIdItinerary;
  }

  factory InterestPoint.fromJson(dynamic json) {
    return InterestPoint(
        idInterestPoint: json['id_interest_point'] as int?,
        typology: int.parse(json['typology'] as String),
        phi: double.parse(json['phi'] as String),
        lambda: double.parse(json['lambda'] as String),
        fkIdItinerary: json['fk_id_itinerary'] as int?);
  }

  @override
  String toString() {
    return '{ "id_interest_point" : $_idInterestPoint, "typology" : $_typology, "phi" : $_phi, "lambda" : $_lambda, "fk_id_itinerary" : $_fkIdItinerary}';
  }

  int get typology => _typology!;

  void setTypology(int value) {
    _typology = value;
  }

  int get idInterestPoint => _idInterestPoint!;

  void setIdInterestPoint(int value) {
    _idInterestPoint = value;
  }

  double get phi => _phi!;

  void setPhi(double value) {
    _phi = value;
  }

  double get lambda => _lambda!;

  void setLambda(double value) {
    _lambda = value;
  }

  int get fkIdItinerary => _fkIdItinerary!;

  void setFkIdItinerary(int value) {
    _fkIdItinerary = value;
  }

  String getInterestPointTitle(int index) {
    if (index == 1) {
      return 'Punto Panoramico';
    } else if (index == 2) {
      return 'Area Pic-Nic';
    } else if (index == 3) {
      return 'Area Camping';
    } else if (index == 4) {
      return 'Sito Archeologico';
    } else if (index == 5) {
      return 'Sorgente';
    } else if (index == 6) {
      return 'Baita';
    } else if (index == 7) {
      return 'Flora';
    } else if (index == 8) {
      return 'Grotta';
    } else if (index == 9) {
      return 'Fiume';
    } else {
      return 'Kayak';
    }
  }

  String getInterestPointTitleHome(int index) {
    if (index == 1) {
      return 'Veduta';
    } else if (index == 2) {
      return 'Pic-Nic';
    } else if (index == 3) {
      return 'Camping';
    } else if (index == 4) {
      return 'Storico';
    } else if (index == 5) {
      return 'Sorgente';
    } else if (index == 6) {
      return 'Baita';
    } else if (index == 7) {
      return 'Flora';
    } else if (index == 8) {
      return 'Grotta';
    } else if (index == 9) {
      return 'Fiume';
    } else {
      return 'Kayak';
    }
  }


  int getTypology(String title) {
    if (title == 'Punto Panoramico') {
      return 1;
    } else if (title == 'Area Pic-Nic') {
      return 2;
    } else if (title == 'Area Camping') {
      return 3;
    } else if (title == 'Sito Archeologico') {
      return 4;
    } else if (title == 'Sorgente') {
      return 5;
    } else if (title == 'Baita') {
      return 6;
    } else if (title == 'Flora') {
      return 7;
    } else if (title == 'Grotta') {
      return 8;
    } else if (title == 'Fiume') {
      return 9;
    } else {
      return 10;
    }
  }

}
