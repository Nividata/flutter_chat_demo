class UserThreadKey {
  final UserThread msg;
  final String key;

  UserThreadKey({this.msg, this.key});

  factory UserThreadKey.fromJson(String key, Map<dynamic, dynamic> json) {
    return UserThreadKey(key: key, msg: UserThread.fromJson(json));
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        key: msg.toJson(),
      };
}

class UserThread {
  final String owner;

  UserThread({this.owner});

  factory UserThread.fromJson(Map<dynamic, dynamic> json) {
    return UserThread(owner: json['owner'] as String);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'owner': owner,
      };
}
