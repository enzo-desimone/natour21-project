class CognitoAdmin {
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _password;

  CognitoAdmin({
    id,
    firstName,
    lastName,
    email,
    password,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _password = password;
  }

  factory CognitoAdmin.fromJson(dynamic json) {
    return CognitoAdmin(
      id: json['id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      };

  @override
  String toString() {
    return '{$_id, $_firstName, $_lastName, $email, $_password}';
  }

  String? get id => _id;

  set setId(String id) {
    _id = id;
  }

  String? get email => _email;

  set setEmail(String value) {
    _email = value;
  }

  String? get lastName => _lastName;

  set setLastName(String value) {
    _lastName = value;
  }

  String? get firstName => _firstName;

  set setFirstName(String value) {
    _firstName = value;
  }

  String? get password => _password;

  set setPassword(String value) {
    _password = value;
  }
}
