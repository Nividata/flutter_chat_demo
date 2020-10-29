import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/firestore/Ref.dart';
import 'package:flutter_chat_demo/firestream/Chat/UserThread.dart';
import 'package:flutter_chat_demo/firestream/service/FirebaseCoreHandler.dart';
import 'package:flutter_chat_demo/firestream/utility/Path.dart';
import 'package:flutter_chat_demo/firestream/utility/Paths.dart';
import 'package:flutter_chat_demo/firestream/Chat/Threads.dart';
import 'package:flutter_chat_demo/firestream/Chat/user.dart';
import 'package:flutter_chat_demo/firestore/rx/Extension.dart';
import 'package:rxdart/rxdart.dart';

import 'RxFirestore.dart';

class FirestoreCoreHandler extends FirebaseCoreHandler {
  @override
  Stream<void> addUsers(Path path, User user) {
    return Stream.fromFuture(Ref.document(path).setData(user.toJson()));
  }

  @override
  Stream<List<User>> getAllUserList(Path path, String uid) {
    return RxFirestore()
        .getByQuery(Ref.collection(Paths.usersPath()))
        .parseToListOfListData()
        .where((event) => event.id != uid)
        .map((event) => User.fromListData(event))
        .toList()
        .asStream();
  }

  @override
  Stream<List<Thread>> getAllActiveChatUserList(Path path) {
    return getUserMessageThreadList(Paths.messagesPath())
        .expand((element) => element)
        .transform(FlatMapStreamTransformer((UserThread x) => RxFirestore()
                .getByQuery(Ref.collection(Paths.chatsPath())
                    .where(FieldPath.documentId, isEqualTo: x.id))
                .parseToListOfListData()
                .map((event) {
              return Thread.fromListData(event);
            })))
        .toList()
        .asStream();
  }

  @override
  Stream<List<UserThread>> getUserMessageThreadList(Path path) {
    return RxFirestore()
        .getByQuery(Ref.collection(Paths.messagesPath()))
        .map((event) {
          print(event);
          return event;
        })
        .parseToListOfListData()
        .map((event) {
          print(UserThread.fromListData(event).toJson());
          return UserThread.fromListData(event);
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
