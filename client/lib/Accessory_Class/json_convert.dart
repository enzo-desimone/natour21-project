class JsonConvert {
  String? _type;
  String? _dateTime;
  String? _table;

  JsonConvert({
    type,
    dateTime,
    table,
  }) {
    _type = type;
    _dateTime = dateTime;
    _table = table;
  }

  factory JsonConvert.fromJson(dynamic json) {
    return JsonConvert(
      type: json['type'] as String?,
      dateTime: json['dateTime'] as String?,
      table: json['table'] as String?,
    );
  }

  @override
  String toString() {
    return '{$_type, $_dateTime, $_table}';
  }

  String? get table => _table;

  set setTable(String value) {
    _table = value;
  }

  String? get dateTime => _dateTime;

  set setDateTime(String value) {
    _dateTime = value;
  }

  String? get type => _type;

  set setType(String value) {
    _type = value;
  }
}