import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/models/response/FbMessage.dart';
import 'package:flutter_chat_demo/models/response/Message.dart';
import 'package:flutter_chat_demo/models/response/Threads.dart';
import 'package:flutter_chat_demo/services/authentication_service.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/transformers.dart';
import 'package:tuple/tuple.dart';

@lazySingleton
class FirebaseDbService {
  AuthenticationService _authenticationService;

  FirebaseDbService(this._authenticationService);

  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Stream<void> authenticate(Map<String, dynamic> data) {
    return Stream.fromFuture(_authenticationService.currentUser()).transform(
        FlatMapStreamTransformer((FirebaseUser user) => Stream.fromFuture(
            _firebaseDatabase
                .reference()
                .child("users")
                .child(user.uid)
                .update(data))));
  }

  Stream<FirebaseUser> currentUser() =>
      Stream.fromFuture(_authenticationService.currentUser());

  Stream<UserKey> currentUserData() => currentUser().flatMap(
      (FirebaseUser user) => Stream.fromFuture(_firebaseDatabase
                  .reference()
                  .child("users")
                  .child(user.uid)
                  .once())
              .map((DataSnapshot snapshot) {
            print(UserKey.fromJson(snapshot.key,
                    snapshot.value as LinkedHashMap<dynamic, dynamic>)
                .toJson());
            return UserKey.fromJson(snapshot.key,
                snapshot.value as LinkedHashMap<dynamic, dynamic>);
          }));

  Stream<List<ThreadKey>> getAllThreadList() {
    return Stream.fromFuture(
            _firebaseDatabase.reference().child("threads").once())
        .map((DataSnapshot snapshot) {
          return (snapshot.value as LinkedHashMap<dynamic, dynamic>).entries;
        })
        .expand((element) => element)
        .map((event) {
          print(ThreadKey.fromJson(event.key, event.value).toJson());
          return ThreadKey.fromJson(event.key, event.value);
        })
        .toList()
        .asStream();
  }

  Stream<List<UserKey>> getAllUserList() {
    return Stream.fromFuture(
            _firebaseDatabase.reference().child("users").once())
        .map((DataSnapshot snapshot) {
          return (snapshot.value as LinkedHashMap<dynamic, dynamic>).entries;
        })
        .expand((element) => element)
        .map((event) {
          print(
              "UserKey  ${UserKey.fromJson(event.key, event.value).toJson()}");
          return UserKey.fromJson(event.key, event.value);
        })
        .toList()
        .asStream();
  }

  Stream<ThreadKey> createThreadByUser(UserKey otherUser) {
    return currentUserData()
        .map((UserKey currentUser) => currentUser.user.msgKey)
        .expand((element) => element)
        .map((event) => event.key)
        .where(
            (event) => otherUser.user.msgKey.map((e) => e.key).contains(event))
        .defaultIfEmpty("")
        .flatMap((value) {
      if (value.isEmpty) {
        return createMessageThread("oneToOne", otherUser);
      } else {
        return getThreadByMsgKey(value);
      }
    });
  }

  Stream<ThreadKey> createMessageThread(String name, UserKey otherUser) {
    return currentUser()
        .flatMap((FirebaseUser currentUser) => Stream.value(Tuple2(
            currentUser.uid,
            _firebaseDatabase
                .reference()
                .child("users")
                .child(currentUser.uid)
                .child("message")
                .push()
                .key)))
        .flatMap((Tuple2 tuple2) => ZipStream([
              Stream.fromFuture(_firebaseDatabase
                  .reference()
                  .child("users")
                  .child(tuple2.item1)
                  .child("message")
                  .child(tuple2.item2)
                  .update({"owner": "${tuple2.item1}"})),
              Stream.fromFuture(_firebaseDatabase
                  .reference()
                  .child("users")
                  .child(otherUser.key)
                  .child("message")
                  .child(tuple2.item2)
                  .update({"owner": "${otherUser.key}"})),
              Stream.fromFuture(_firebaseDatabase
                  .reference()
                  .child("threads")
                  .child(tuple2.item2)
                  .update(
                      Thread(name: name, type: "oneToOne", owner: tuple2.item1)
                          .toJson())),
            ], (List<void> b) => b.length.toString())
                .flatMap((value) => getThreadByMsgKey(tuple2.item2)));
  }

  Stream<ThreadKey> getThreadByMsgKey(String msgKey) {
    return Stream.fromFuture(_firebaseDatabase
            .reference()
            .child("threads")
            .orderByKey()
            .equalTo(msgKey)
            .once())
        .map((DataSnapshot snapshot) {
          return (snapshot.value as LinkedHashMap<dynamic, dynamic>).entries;
        })
        .expand((element) => element)
        .map((event) {
          print(ThreadKey.fromJson(event.key, event.value));
          return ThreadKey.fromJson(event.key, event.value);
        });
  }

  Stream<List<ThreadKey>> getThreadList() {
    return currentUser()
        .flatMap((FirebaseUser user) => Stream.fromFuture(_firebaseDatabase
                .reference()
                .child("users")
                .child(user.uid)
                .child("message")
                .once())
            .map((DataSnapshot snapshot) {
              if (snapshot.value != null)
                return (snapshot.value as LinkedHashMap<dynamic, dynamic>)
                    .entries;
              else
                throw Exception("no thread data");
            })
            .expand((element) => element)
            .map((event) {
              print(MsgKey.fromJson(event.key, event.value).toJson());
              return MsgKey.fromJson(event.key, event.value);
            }))
        .flatMap((value) => Stream.fromFuture(_firebaseDatabase
                .reference()
                .child("threads")
                .orderByKey()
                .equalTo(value.key)
                .once())
            .map((DataSnapshot snapshot) {
              return (snapshot.value as LinkedHashMap<dynamic, dynamic>)
                  .entries;
            })
            .expand((element) => element)
            .map((event) {
              print(ThreadKey.fromJson(event.key, event.value).toJson());
              return ThreadKey.fromJson(event.key, event.value);
            }))
        .toList()
        .asStream();
  }

  Stream<Message> sendMessage(ThreadKey threads, Message message) {
    return Stream.fromFuture(_authenticationService.currentUser())
        .flatMap((FirebaseUser value) {
      message.from = value.uid;
      message.isMe = true;
      return Stream.fromFuture(_firebaseDatabase
              .reference()
              .child("threads")
              .child(threads.key)
              .child("messages")
              .push()
              .set(message.toFbMessage().toJson()))
          .map((event) => message);
    });
  }

  Stream<List<Message>> getMessage(ThreadKey threads) {
    return currentUser()
        .flatMap((FirebaseUser user) => Stream.fromFuture(_firebaseDatabase
                .reference()
                .child("threads")
                .child(threads.key)
                .child("messages")
                .once())
            .map((DataSnapshot snapshot) => Tuple2(user, snapshot)))
        .flatMap((Tuple2<FirebaseUser, DataSnapshot> tuple2) {
      if (tuple2.item2.value == null) {
        return Stream.value(<Message>[]);
      } else {
        return Stream.value(
                (tuple2.item2.value as LinkedHashMap<dynamic, dynamic>).entries)
            .expand((element) => element)
            .map((event) {
              print(FbMessageKey.fromJson(event.key, event.value).toJson());
              return FbMessageKey.fromJson(event.key, event.value);
            })
            .map((FbMessageKey fbMessage) =>
                Message.fromFbMessageKey(fbMessage, tuple2.item1.uid))
            .toList()
            .asStream();
      }
    });
  }
}
