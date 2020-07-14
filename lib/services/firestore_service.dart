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
        FlatMapStreamTransformer((FirebaseUser user) =>
            Stream.fromFuture(
                _firebaseDatabase
                    .reference()
                    .child("users")
                    .child(user.uid)
                    .update(data))));
  }


  Stream<FirebaseUser> currentUser() =>
      Stream.fromFuture(_authenticationService.currentUser());


  Stream<UserKey> currentUserData() =>
      currentUser().flatMap((FirebaseUser user) =>
          Stream.fromFuture(_firebaseDatabase
              .reference()
              .child("users")
              .child(user.uid)
              .once()).map((DataSnapshot snapshot) {
            print(UserKey.fromJson(
                snapshot.key, snapshot.value as LinkedHashMap<dynamic, dynamic>)
                .toJson());
            return UserKey.fromJson(
                snapshot.key,
                snapshot.value as LinkedHashMap<dynamic, dynamic>);
          })
      );

  Stream<List<Threads>> getAllThreadList() {
    return Stream.fromFuture(_firebaseDatabase
        .reference()
        .child("threads")
        .once()).map((DataSnapshot snapshot) {
      print(snapshot.key);
      print(snapshot.value);
      print((snapshot.value as LinkedHashMap<dynamic, dynamic>).values);
      return (snapshot.value as LinkedHashMap<dynamic, dynamic>).values;
    })
        .expand((element) => element)
        .map((event) {
      print(event);
      print(Threads.fromJson("sd", event).toJson());
      return Threads.fromJson("sd", event);
    }).toList().asStream();
  }

  Stream<List<UserKey>> getAllUserList() {
    return Stream.fromFuture(_firebaseDatabase
        .reference()
        .child("users")
        .once())
        .map((DataSnapshot snapshot) {
      return (snapshot.value as LinkedHashMap<dynamic, dynamic>).entries;
    })
        .expand((element) => element)
        .map((event) {
      print(event);
      print(event.runtimeType);
      return event;
    })
        .map((event) {
      print("UserKey  ${UserKey.fromJson(event.key, event.value).toJson()}");
      return UserKey.fromJson(event.key, event.value);
    }).toList().asStream();
  }

  createThreadByUser(UserKey otherUser) {
    return currentUserData()
        .map((event) {
      print("otherUser  ${otherUser.toJson()}");
      print("currentUser  ${event.toJson()}");
      return event;
    }).map((UserKey currentUser) {
      print(currentUser.user.msgKey);
      return currentUser.user.msgKey;
    })
        .expand((element) => element)
        .map((event) {
      print(event.key);
      return event.key;
    })
        .where((event) {
      print(otherUser.user.msgKey.map((e) => e.key).contains(event));
      return otherUser.user.msgKey.map((e) => e.key).contains(event);
    }).defaultIfEmpty("")
        .flatMap((value) {
      if (value.isEmpty) {
        return createMessageThread("oneToOne", otherUser);
      } else {
        return getThreadByMsgKey(value);
      }
    }).listen((event) {
      print(event.runtimeType);
      print(event.toJson());
    }, onError: (e) {
      print(e);
    });
  }

  Stream<Threads> createMessageThread(String name, UserKey otherUser) {
    return currentUser()
        .flatMap((FirebaseUser currentUser) =>
        Stream.value(
            Tuple2(
                currentUser.uid,
                _firebaseDatabase
                    .reference()
                    .child("users")
                    .child(currentUser.uid)
                    .child("message")
                    .push()
                    .key)))
        .flatMap((Tuple2 tuple2) =>
        ZipStream([
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
              Threads(name: name, type: "oneToOne", owner: tuple2.item1)
                  .toJson())),
        ], (List<void> b) => b.length.toString()
        ).flatMap((value) => getThreadByMsgKey(tuple2.item2))
    );
  }

  Stream<Threads> getThreadByMsgKey(String msgKey) {
    return Stream.fromFuture(_firebaseDatabase
        .reference()
        .child("threads")
        .orderByKey()
        .equalTo(msgKey)
        .once())
        .map((DataSnapshot snapshot) {
      print(snapshot.key);
      print(snapshot.value);
      print((snapshot.value as LinkedHashMap<dynamic, dynamic>).values);
      return (snapshot.value as LinkedHashMap<dynamic, dynamic>).values;
    }).expand((element) => element)
        .map((event) {
      print(event);
      print(Threads.fromJson("sd", event).toJson());
      return Threads.fromJson("sd", event);
    });
  }

  Stream<List<Threads>> getThreadList() {
    return Stream.fromFuture(_authenticationService.currentUser())
        .transform(FlatMapStreamTransformer((FirebaseUser user) =>
        Stream.fromFuture(_firebaseDatabase
            .reference()
            .child("users")
            .child(user.uid)
            .child("message")
            .once())
            .map((DataSnapshot snapshot) =>
        snapshot.value as Map<dynamic, dynamic>)
            .map((Map<dynamic, dynamic> event) {
          return event.keys.toList();
        })))
        .flatMapIterable((value) => Stream.value(value))
        .flatMap<Threads>((dynamic value) =>
        Stream.fromFuture(_firebaseDatabase
            .reference()
            .child("threads")
            .orderByKey()
            .equalTo(value)
            .once())
            .map((DataSnapshot snapshot) =>
            Threads.fromJson(
                (snapshot.value as LinkedHashMap<dynamic, dynamic>).keys
                    .first,
                (snapshot.value as LinkedHashMap<dynamic, dynamic>)
                    .values
                    .first)))
        .toList()
        .asStream();
  }

  Stream<void> sendMessage(Threads threads, Message message) {
    return Stream.fromFuture(_authenticationService.currentUser()).flatMap((
        FirebaseUser
        value) {
      var msg = message.toFbMessage();
      msg.meta.from = value.uid;
      return Stream.fromFuture(_firebaseDatabase
          .reference()
          .child("threads")
          .child(threads.key)
          .child("messages")
          .push().set(message.toJson())
      );
    });
  }

  Stream<List<Message>> getMessage(Threads threads) {
    return Stream
        .fromFuture(_authenticationService.currentUser())
        .transform(FlatMapStreamTransformer((FirebaseUser user) =>
        Stream.fromFuture(_firebaseDatabase
            .reference()
            .child("threads")
            .child(threads.key)
            .child("messages")
            .once())))
        .flatMap((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        return Stream.value(<Message>[]);
      }
      else {
        return Stream.value(
            (snapshot.value as LinkedHashMap<dynamic, dynamic>).values)
            .expand((element) => element)
            .map((event) {
          print(FbMessage.fromJson(event).toJson());
          return FbMessage.fromJson(event);
        }).map((FbMessage fbMessage) =>
            Message.fromFbMessage(fbMessage, "XFiyZE7K4oSXdb93TDhrTRZvzCs2"))
            .toList().asStream();
      }
    }

    );
  }
}
