import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Message {
  String type;
  MessageData data;
  String time;

  Message({this.type, this.data, this.time});

  factory Message.fromJson(Map<dynamic, dynamic> json) => Message(
        type: json['type'] as String,
        data: MessageData.fromJson(json['data'] as Map<dynamic, dynamic>),
        time: json['time'] as String,
      );

  Map<dynamic, dynamic> toJson() => {
        'type': type,
        'data': data.toJson(),
        'time': time,
      };
}

class MessageData {
  String text;

  MessageData({this.text});

  static MessageData fromJson(Map<dynamic, dynamic> map) =>
      MessageData(text: map["text"]);

  Map<dynamic, dynamic> toJson() => {"text": text};
}
