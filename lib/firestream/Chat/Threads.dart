import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_demo/firestream/FireStream.dart';
import 'package:flutter_chat_demo/firestream/utility/Keys.dart';
import 'package:flutter_chat_demo/realtime/model/ListData.dart';
import 'package:flutter_chat_demo/firestream/Extension.dart';

class Thread {
  String id;
  String creator;
  String name;
  int type;
  MessageMeta meta;
  List<MessageUser> userList;

  Thread(
      {@required this.name,
      @required this.creator,
      @required this.type,
      @required List<String> idList}) {
    meta = MessageMeta(name: name, creator: creator, type: type);
    userList =
        idList.map((e) => MessageUser(status: Keys.member)..setId(e)).toList();
  }

  Thread.empty();

  setId(String id) {
    this.id = id;
  }

  factory Thread.fromJson(Map<dynamic, dynamic> json) {
    Thread thread = Thread.empty();
    return thread;
  }

  factory Thread.fromListData(ListData listData) {
    Thread thread = Thread.empty();
    thread.setId(listData.id);
    thread.meta = MessageMeta.fromJson(listData.data[Keys.meta]);
    thread.userList =
        (listData.data[Keys.users] as LinkedHashMap<dynamic, dynamic>)
            .entries
            .map((e) => MessageUser.fromListData(ListData(e.key, e.value)))
            .toList();
    return thread;
  }

  Map<String, dynamic> toJson() => {
        Keys.meta: meta.toJson(),
        Keys.users: userList.map((e) => e.toJson()).toList().asFirebaseMap(),
      };
}

class MessageUser {
  String id;
  String status;

  MessageUser({@required this.status});

  setId(String id) {
    this.id = id;
  }

  factory MessageUser.fromListData(ListData listData) {
    MessageUser messageUser =
        MessageUser(status: listData.data[Keys.status] as String);
    messageUser.setId(listData.id);
    return messageUser;
  }

  factory MessageUser.fromJson(Map<dynamic, dynamic> json) {
    return MessageUser(
      status: json[Keys.status] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        id: {Keys.status: status}
      };
}

class MessageMeta {
  int creationDate;
  String creator;
  String name;
  int type;

  MessageMeta(
      {@required this.name,
      @required this.creator,
      @required this.type,
      this.creationDate});

  factory MessageMeta.fromJson(Map<dynamic, dynamic> json) {
    return MessageMeta(
      creationDate: json[Keys.creationDate] as int,
      creator: json[Keys.creator] as String,
      name: json[Keys.name] as String,
      type: json[Keys.type] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        Keys.type: type,
        Keys.name: name,
        Keys.creator: creator,
        Keys.creationDate: FireStream.shared().timestamp()
      };
}
