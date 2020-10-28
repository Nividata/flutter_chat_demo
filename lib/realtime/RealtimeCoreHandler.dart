import 'package:fimber/fimber.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/firestream/Chat/UserThread.dart';
import 'package:flutter_chat_demo/firestream/service/FirebaseCoreHandler.dart';
import 'package:flutter_chat_demo/firestream/utility/Path.dart';
import 'package:flutter_chat_demo/firestream/utility/Paths.dart';
import 'package:flutter_chat_demo/firestream/Chat/Threads.dart';
import 'package:flutter_chat_demo/realtime/RXRealtime.dart';
import 'package:flutter_chat_demo/firestream/Chat/user.dart';
import 'package:flutter_chat_demo/realtime/rx/Extension.dart';
import 'package:rxdart/rxdart.dart';

import 'Ref.dart';

class RealtimeCoreHandler extends FirebaseCoreHandler {
  @override
  Stream<void> addUsers(Path path, User user) {
    return Stream.fromFuture(Ref.get(path).update(user.toJson()));
  }

  @override
  Stream<List<User>> getAllUserList(Path path, String uid) {
    return RXRealtime()
        .get(Ref.get(path))
        .parseToListOfListData()
        .where((event) => event.id != uid)
        .map((event) => User.fromListData(event))
        .toList()
        .asStream();
  }

  @override
  Stream<List<ThreadKey>> getAllActiveChatUserList(Path path) {
    Query query = Ref.get(path).orderByKey();
    return getUserMessageThreadList(Paths.messagesPath())
        .expand((element) => element)
        .flatMap((value) => RXRealtime()
                .get(query.equalTo(value.key))
                .parseToListOfListData()
                .map((event) {
              print(ThreadKey.fromJson(event.id, event.data).toJson());
              return ThreadKey.fromJson(event.id, event.data);
            }))
        .toList()
        .asStream();
  }

  @override
  Stream<List<UserThreadKey>> getUserMessageThreadList(Path path) {
    print(path.toString());
    return RXRealtime()
        .get(Ref.get(path))
        .map((event) {
          print(event);
          return event;
        })
        .parseToListOfListData()
        .map((event) {
          print(
              UserThreadKey(key: event.id, msg: UserThread.fromJson(event.data))
                  .toJson());
          return UserThreadKey(
              key: event.id, msg: UserThread.fromJson(event.data));
        })
        .toList()
        .asStream();
  }

  @override
  Stream<void> updateUsers(String path, Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Map<String, String> timestamp() {
    return ServerValue.timestamp;
  }
}
