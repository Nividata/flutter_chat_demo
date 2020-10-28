import 'dart:collection';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/firestream/Chat/UserThread.dart';
import 'package:flutter_chat_demo/firestream/FireStream.dart';
import 'package:flutter_chat_demo/firestream/utility/Keys.dart';
import 'package:flutter_chat_demo/realtime/model/ListData.dart';
import 'package:meta/meta.dart';

class User {
  String id;
  String name;
  String pictureUrl;
  int lastOnline;
  Map<String, dynamic> meta = Map();
  List<UserThreadKey> userThread;

  User({@required this.name});

  setId(String id) {
    this.id = id;
  }

  setPictureUrl(String pictureUrl) {
    this.pictureUrl = pictureUrl;
  }

  setMeta(Map<String, dynamic> meta) {
    this.meta.addAll(meta);
  }

  _setUserThread(List<UserThreadKey> userThread) {
    this.userThread = userThread;
  }

  factory User.fromJson(Map<dynamic, dynamic> json) {
    Map<String, dynamic> metaMap =
        (json[Keys.meta] as LinkedHashMap<dynamic, dynamic>).cast() ?? {};

    User user = User(name: metaMap[Keys.name] as String);
    user.lastOnline = json[Keys.lastOnline];
    user.setPictureUrl(metaMap[Keys.pictureURL] as String ?? "");
    user.setMeta(metaMap);
    user._setUserThread(json.containsKey(Keys.chats)
        ? (json[Keys.chats] as LinkedHashMap<dynamic, dynamic>)
            .entries
            .map((e) => UserThreadKey.fromJson(e.key, e.value))
            .toList()
        : []);

    return user;
  }

  factory User.fromListData(ListData listData) {
    Map<String, dynamic> metaMap =
        (listData.data[Keys.meta] as LinkedHashMap<dynamic, dynamic>).cast() ??
            {};

    User user = User(name: metaMap[Keys.name] as String);
    user.setId(listData.id);

    user.lastOnline = listData.data[Keys.lastOnline];
    user.setPictureUrl(metaMap[Keys.pictureURL] as String ?? "");
    user.setMeta(metaMap);
    user._setUserThread(listData.data.containsKey(Keys.chats)
        ? (listData.data[Keys.chats] as LinkedHashMap<dynamic, dynamic>)
            .entries
            .map((e) => UserThreadKey.fromJson(e.key, e.value))
            .toList()
        : []);

    return user;
  }

  Map<String, dynamic> toJson() {
    meta[Keys.availability] = Keys.availability;
    meta[Keys.name] = name;
    meta[Keys.nameLowercase] = name.toLowerCase();
    meta[Keys.pictureURL] = pictureUrl;
    return <String, dynamic>{
      Keys.meta: meta ?? {},
      Keys.lastOnline: FireStream.shared().timestamp(),
    };
  }
}
