import 'package:json_annotation/json_annotation.dart';

part 'Message.g.dart';

@JsonSerializable()
class Message {
  num type;
  String name;
  String image;
  String message;

  Message({this.type, this.name, this.image, this.message});

  factory Message.fromJson(Map<dynamic, dynamic> json) => _$messageFromJson(json);

  Map<dynamic, dynamic> toJson() => _$messageToJson(this);
}

