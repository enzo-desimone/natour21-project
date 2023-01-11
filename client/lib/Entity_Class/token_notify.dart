class TokenNotify {
  String? _idTokenNotify;
  String? _fkIdKey;

  TokenNotify({idTokenNotify}) {
    _idTokenNotify = idTokenNotify;
  }

  factory TokenNotify.fromJson(dynamic json) {
    return TokenNotify(idTokenNotify: json['id_token_notify'] as String?);
  }

  @override
  String toString() {
    return '{ $_idTokenNotify, $_fkIdKey}';
  }

  String? get fkIdKey => _fkIdKey;

  set setFkIdKey(String value) {
    _fkIdKey = value;
  }

  String? get idTokenNotify => _idTokenNotify;

  set setIdTokenNotify(String value) {
    _idTokenNotify = value;
  }
}
