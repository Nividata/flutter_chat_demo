class FbMessageKey {
  final FbMessage fbMessage;
  final String key;

  FbMessageKey({this.fbMessage, this.key});

  factory FbMessageKey.fromJson(String key, Map<dynamic, dynamic> json) {
    return FbMessageKey(key: key, fbMessage: FbMessage.fromJson(json));
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        key: fbMessage.toJson(),
      };
}

class FbMessage {
  String type;
  MessageData data;
  MessageMeta meta;

  FbMessage({this.type, this.data, this.meta});

  factory FbMessage.fromJson(Map<dynamic, dynamic> json) => FbMessage(
        type: json['type'] as String,
        data: MessageData.fromJson(json['data'] as Map<dynamic, dynamic>),
        meta: MessageMeta.fromJson(json['meta'] as Map<dynamic, dynamic>),
      );

  Map<dynamic, dynamic> toJson() => {
        'type': type,
        'data': data.toJson(),
        'meta': meta.toJson(),
      };
}

class MessageMeta {
  String time;
  String from;

  MessageMeta({this.from, this.time});

  static MessageMeta fromJson(Map<dynamic, dynamic> map) => MessageMeta(
        from: map["from"],
        time: map["time"],
      );

  Map<dynamic, dynamic> toJson() => {"from": from, "time": time};
}

class MessageData {
  String text;

  MessageData({this.text});

  static MessageData fromJson(Map<dynamic, dynamic> map) =>
      MessageData(text: map["text"]);

  Map<dynamic, dynamic> toJson() => {"text": text};
}
