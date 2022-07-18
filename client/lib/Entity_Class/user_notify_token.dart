class UserNotifyToken {
  String? _notifyToken;

  UserNotifyToken({notifyToken}) {
    _notifyToken = notifyToken;
  }

  factory UserNotifyToken.fromJson(dynamic json) {
    return UserNotifyToken(notifyToken: json['notify_token'] as String?);
  }

  @override
  String toString() {
    return '$_notifyToken';
  }

  String? get notifyToken => _notifyToken;
}
