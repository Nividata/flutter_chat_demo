import 'dart:collection';

import 'package:flutter_chat_demo/firestream/Chat/UserThread.dart';
import 'package:meta/meta.dart';

class UserKey {
  final User user;
  final String key;

  UserKey({this.user, this.key});

  factory UserKey.fromJson(String key, Map<dynamic, dynamic> json) {
    return UserKey(key: key, user: User.fromJson(json));
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        key: user.toJson(),
      };
}

class User {
  final String name, avatarUrl;
  final Map<String, dynamic> extras;
   List<UserThreadKey> msgKey;

  User({
    @required this.name,
    this.avatarUrl,
    this.msgKey,
    this.extras,
  });

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
        name: json['name'] as String,
        avatarUrl: json['avatar_url'] as String ?? "",
        extras: json['extras'] as Map<String, dynamic> ?? {},
        msgKey: json.containsKey('message')
            ? (json['message'] as LinkedHashMap<dynamic, dynamic>)
                .entries
                .map((e) => UserThreadKey.fromJson(e.key, e.value))
                .toList()
            : []);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'avatar_url': avatarUrl ?? "",
        'extras': extras ?? {},
        'message': msgKey != null ? msgKey.map((e) => e.toJson()).join(",") : {}
      };
}
