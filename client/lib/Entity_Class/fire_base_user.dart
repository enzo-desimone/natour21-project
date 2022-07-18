import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

class FireBaseUser {
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _bornDate;
  String? _gender;
  String? _email;
  DateTime? _lastSeen;
  DateTime? _regDate;
  bool? _firstLogin;
  String? _avatar;
  int? _loginCounter;

  FireBaseUser(
      {id,
      firstName,
      lastName,
      bornDate,
      gender,
      email,
      lastSeen,
      regDate,
      firstLogin,
      avatar,
      loginCounter}) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _bornDate = bornDate;
    _gender = gender;
    _email = email;
    _lastSeen = lastSeen;
    _regDate = regDate;
    _firstLogin = firstLogin;
    _avatar = avatar;
    _loginCounter = loginCounter;
  }

  factory FireBaseUser.fromJson(dynamic json) {
    Timestamp? _tempLastSeen;
    Timestamp? _tempRegDate;

    if (json['last_seen'].runtimeType.toString() != 'DateTime') {
      _tempLastSeen = json['last_seen'];
    }

    if (json['reg_date'].runtimeType.toString() != 'DateTime') {
      _tempRegDate = json['reg_date'];
    }
    return FireBaseUser(
        id: json['id'] as String?,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        bornDate: json['born_date'] as String?,
        gender: json['gender'] as String?,
        email: json['email'] as String?,
        lastSeen:
            _tempLastSeen != null ? _tempLastSeen.toDate() : json['last_seen'],
        regDate:
            _tempRegDate != null ? _tempRegDate.toDate() : json['reg_date'],
        firstLogin: json['first_login'] as bool?,
        avatar: json['avatar'] as String?,
        loginCounter: json['login_counter'] as int?);
  }

  factory FireBaseUser.fromJsonFacebook(dynamic json) {
    return FireBaseUser(
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        bornDate: json['born_date'] as String?,
        gender: json['gender'] as String?,
        email: json['email'] as String?,
        avatar: json['picture']['data']['url'] as String?,
        loginCounter: json['login_counter'] as int?);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'born_date': bornDate,
        'gender': gender,
        'email': email,
        'last_seen': lastSeen,
        'reg_date': regDate,
        'first_login': firstLogin,
        'avatar': avatar,
        'login_counter': loginCounter
      };

  @override
  String toString() {
    return '{$_id, $_firstName, $_lastName, $_bornDate, $_gender,  $email, $_lastSeen, $_regDate, $_firstLogin,  $_avatar, $_loginCounter}';
  }

  String? get id => _id;

  set setId(String id) {
    _id = id;
  }

  int? get loginCounter => _loginCounter;

  set setLoginCounter(int count) {
    _loginCounter = count;
  }

  String? get avatar => _avatar;

  set setAvatar(String value) {
    _avatar = value;
  }

  bool? get firstLogin => _firstLogin;

  set setFirstLogin(bool value) {
    _firstLogin = value;
  }

  DateTime? get lastSeen => _lastSeen;

  set setLastSeen(DateTime value) {
    _lastSeen = value;
  }

  String? get email => _email;

  set setEmail(String value) {
    _email = value;
  }

  String? get gender => _gender;

  set setGender(String value) {
    _gender = value;
  }

  String? get bornDate => _bornDate;

  set setBornDate(String value) {
    _bornDate = value;
  }

  String? get lastName => _lastName;

  set setLastName(String value) {
    _lastName = value;
  }

  String? get firstName => _firstName;

  set setFirstName(String value) {
    _firstName = value;
  }

  DateTime? get regDate => _regDate;

  set setRegDate(DateTime value) {
    _regDate = value;
  }

  String getLastSeenExplicit() {
    return lastSeen!.day.toString() +
        ' ' +
        DateFormat.MMMM().format(lastSeen!) +
        ' ' +
        lastSeen!.year.toString() +
        ' | ' +
        lastSeen!.hour.toString() +
        ':' +
        lastSeen!.minute.toString();
  }

  String getRegDateExplicit() {
    return regDate!.day.toString() +
        ' ' +
        DateFormat.MMMM().format(regDate!) +
        ' ' +
        regDate!.year.toString();
  }

  String getBornDateExplicit() {
    DateTime _temp = DateFormat("dd-MM-yyyy").parse(bornDate!);

    return _temp.day.toString() +
        ' ' +
        DateFormat.MMMM().format(_temp) +
        ' ' +
        _temp.year.toString();
  }
}
