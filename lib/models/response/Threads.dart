import 'package:firebase_database/firebase_database.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Threads {
  String key;
  String owner;
  String name;
  String type;

  Threads({this.key, this.owner, this.name, this.type});

  static Threads fromJson(String key, Map<dynamic, dynamic> json) {
    return Threads(
      key: key,
      type: json['type'] as String,
      owner: json['owner'] as String,
      name: json['name'] as String,
    );
  }

  Map<dynamic, dynamic> toJson() => {
        'key': key,
        'type': type,
        'name': name,
        'owner': owner,
      };

  static Threads fromSnapshot(DataSnapshot snapshot) {
    return Threads(
      type: snapshot.value["type"],
      name: snapshot.value["name"],
      owner: snapshot.value["owner"],
    );
//    key = snapshot.key,
  }
}
