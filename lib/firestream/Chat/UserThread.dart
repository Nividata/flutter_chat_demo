import 'package:flutter_chat_demo/firestream/utility/Keys.dart';
import 'package:flutter_chat_demo/realtime/model/ListData.dart';

class UserThread {
  final String invitedBy;
  String id;

  UserThread({this.invitedBy});

  setId(String id) {
    this.id = id;
  }

  factory UserThread.fromListData(ListData listData) {
    UserThread userThread =
        UserThread(invitedBy: listData.data[Keys.invitedBy] as String);
    userThread.setId(listData.id);
    return userThread;
  }

  factory UserThread.fromJson(Map<dynamic, dynamic> json) {
    return UserThread(invitedBy: json[Keys.invitedBy] as String);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        Keys.invitedBy: invitedBy,
      };
}
