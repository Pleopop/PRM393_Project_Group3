import 'dart:convert';

class UserModel {
  final String token;
  final String username;
  final String? avatar;

  const UserModel({required this.token, required this.username, this.avatar});

  /// Backend returns: { token, username, avatar }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'username': username,
    'avatar': avatar,
  };

  String toJsonString() => jsonEncode(toJson());

  UserModel copyWith({String? token, String? username, String? avatar}) {
    return UserModel(
      token: token ?? this.token,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
    );
  }
}
