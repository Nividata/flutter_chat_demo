import 'package:flutter_chat_demo/firestream/Chat/FbMessage.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Message {
  String msgType;
  bool isMe;
  String time;
  String from;
  String text;

  Message({this.msgType, this.isMe, this.time, this.from, this.text});

  factory Message.fromJson(Map<dynamic, dynamic> json) =>
      Message(
          msgType: json['msgType'] as String,
          isMe: json['isMe'] as bool,
          time: json['time'] as String,
          from: json['from'] as String,
          text: json['text'] as String);

  Map<String, dynamic> toJson() =>
      {
        'msgType': msgType,
        'isMe': isMe,
        'time': time,
        'from': from,
        'text': text,
      };

  factory Message.fromFbMessageKey(FbMessageKey fbMessageKey, String uid) =>
      Message(
          msgType: fbMessageKey.fbMessage.type,
          text: fbMessageKey.fbMessage.data.text,
          from: fbMessageKey.fbMessage.meta.from,
          time: fbMessageKey.fbMessage.meta.time,
          isMe: fbMessageKey.fbMessage.meta.from == uid);

  FbMessage toFbMessage() =>
      FbMessage(
          type: msgType,
          meta: MessageMeta(from: from, time: time),
          data: MessageData(text: text)
      );
}
