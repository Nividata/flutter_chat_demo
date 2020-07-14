import 'package:firebase_database/firebase_database.dart';

class ThreadKey {
  final Thread thread;
  final String key;

  ThreadKey({this.thread, this.key});

  factory ThreadKey.fromJson(String key, Map<dynamic, dynamic> json) {
    return ThreadKey(key: key, thread: Thread.fromJson(json));
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        key: thread.toJson(),
      };
}

class Thread {
  String owner;
  String name;
  String type;

  Thread({this.owner, this.name, this.type});

  static Thread fromJson(Map<dynamic, dynamic> json) {
    return Thread(
      type: json['type'] as String,
      owner: json['owner'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'owner': owner,
      };

  static Thread fromSnapshot(DataSnapshot snapshot) {
    return Thread(
      type: snapshot.value["type"],
      name: snapshot.value["name"],
      owner: snapshot.value["owner"],
    );
//    key = snapshot.key,
  }
}
