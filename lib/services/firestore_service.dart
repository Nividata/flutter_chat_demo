import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_demo/Repository.dart';
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
class FirestoreService implements Repository {
  AuthenticationService _authenticationService;

  FirestoreService(this._authenticationService);

  final Firestore _firestore = Firestore.instance;

  @override
  Stream<FirebaseUser> currentUser() {
    return Stream.fromFuture(_authenticationService.currentUser());
  }

  @override
  Stream<void> authenticate(Map<String, dynamic> data) {
    return currentUser().flatMap((FirebaseUser user) =>
        Stream.fromFuture(
            _firestore.collection("users").document(user.uid).setData(data)));
  }

  @override
  Stream<UserKey> currentUserData() =>
      currentUser().flatMap((FirebaseUser user) =>
          Stream.fromFuture(
              _firestore.collection("users").document(user.uid).get())
              .flatMap((value) =>
              Stream.fromFuture(_firestore
                  .collection("users")
                  .document(user.uid)
                  .collection("message")
                  .getDocuments())
                  .map((event) => Tuple2(value, event)))
              .map((event) {
            print(UserKey.fromJson(event.item1.documentID,
                event.item1.data as LinkedHashMap<dynamic, dynamic>)
                .toJson());
          })
              .map((DocumentSnapshot snapshot) {
            print(UserKey.fromJson(snapshot.documentID,
                snapshot.data as LinkedHashMap<dynamic, dynamic>)
                .toJson());
            return UserKey.fromJson(snapshot.documentID,
                snapshot.data as LinkedHashMap<dynamic, dynamic>);
          }));

  @override
  Stream<List<ThreadKey>> getAllThreadList() {
    return Stream.fromFuture(_firestore.collection("threads").getDocuments())
        .map((QuerySnapshot snapshot) {
      return snapshot.documents;
    })
        .expand((element) => element)
        .map((event) {
      print(ThreadKey.fromJson(event.documentID, event.data).toJson());
      return ThreadKey.fromJson(event.documentID, event.data);
    })
        .toList()
        .asStream();
  }

  @override
  Stream<List<UserKey>> getAllUserList() {
    return Stream.fromFuture(_firestore.collection("users").getDocuments())
        .map((QuerySnapshot snapshot) {
      return snapshot.documents;
    })
        .expand((element) => element)
        .map((event) {
      print(
          "UserKey  ${UserKey.fromJson(event.documentID, event.data)
              .toJson()}");
      return UserKey.fromJson(event.documentID, event.data);
    })
        .toList()
        .asStream();
  }

  @override
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

  test(UserKey otherUser) {
    currentUserData()
        .map((UserKey currentUser) => currentUser.user.msgKey)
        .expand((element) => element)
        .map((event) => event.key)
        .where(
            (event) => otherUser.user.msgKey.map((e) => e.key).contains(event))
        .listen((event) {
      print("ok ${event}");
    }, onError: (e) {
      print(e);
    });
  }

  @override
  Stream<ThreadKey> createMessageThread(String name, UserKey otherUser) {
    return currentUser()
        .flatMap((FirebaseUser currentUser) =>
        Stream.value(Tuple2(
            currentUser.uid,
            _firestore
                .collection("users")
                .document(currentUser.uid)
                .collection("message")
                .document()
                .documentID)))
        .flatMap((Tuple2 tuple2) =>
        ZipStream([
          Stream.fromFuture(_firestore
              .collection("users")
              .document(tuple2.item1)
              .collection("message")
              .document(tuple2.item2)
              .setData({"owner": "${tuple2.item1}"})),
          Stream.fromFuture(_firestore
              .collection("users")
              .document(otherUser.key)
              .collection("message")
              .document(tuple2.item2)
              .setData({"owner": "${otherUser.key}"})),
          Stream.fromFuture(_firestore
              .collection("threads")
              .document(tuple2.item2)
              .setData(
              Thread(name: name, type: "oneToOne", owner: tuple2.item1)
                  .toJson())),
        ], (List<void> b) => b.length.toString())
            .flatMap((value) => getThreadByMsgKey(tuple2.item2)));
  }

  @override
  Stream<ThreadKey> getThreadByMsgKey(String msgKey) {
    return Stream.fromFuture(
        _firestore.collection("threads").document(msgKey).get())
        .map((DocumentSnapshot snapshot) {
      print(ThreadKey.fromJson(snapshot.documentID, snapshot.data));
      return ThreadKey.fromJson(snapshot.documentID, snapshot.data);
    });
  }

  @override
  Stream<List<ThreadKey>> getThreadList() {
    return currentUser()
        .flatMap((FirebaseUser user) =>
        Stream.fromFuture(_firestore
            .collection("users")
            .document(user.uid)
            .collection("message")
            .getDocuments())
            .map((QuerySnapshot snapshot) {
          print(snapshot.documents);
          if (snapshot.documents.isNotEmpty)
            return snapshot.documents;
          else
            throw Exception("no thread data");
        })
            .expand((element) => element)
            .map((event) {
          print(MsgKey.fromJson(event.documentID, event.data).toJson());
          return MsgKey.fromJson(event.documentID, event.data);
        }))
        .flatMap((value) =>
        Stream.fromFuture(
            _firestore.collection("threads").document(value.key).get())
            .map((DocumentSnapshot snapshot) {
          print(ThreadKey.fromJson(snapshot.documentID, snapshot.data)
              .toJson());
          return ThreadKey.fromJson(snapshot.documentID, snapshot.data);
        }))
        .toList()
        .asStream();
  }

  @override
  Stream<Message> sendMessage(ThreadKey threads, Message message) {
    return currentUser().flatMap((FirebaseUser value) {
      message.from = value.uid;
      message.isMe = true;
      print(message.toFbMessage().toJson());
      return Stream.fromFuture(_firestore
          .collection("threads")
          .document(threads.key)
          .collection("messages")
          .add(message.toFbMessage().toJson()))
          .map((event) => message);
    });
  }

  Stream<Message> getNewMessages(ThreadKey threads) {
    return currentUser()
        .flatMap((FirebaseUser user) =>
        _firestore
            .collection("threads")
            .document(threads.key)
            .collection("messages")
            .limit(10)
            .snapshots()
            .map((event) => event.documents)
            .expand((element) => element)
            .map((event) => Tuple2(user, event)))
        .map((event) {
      print(event.item2.data);
      print(event.item2.documentID);
      if (event.item2.data != null)
        return Message.fromFbMessageKey(
            FbMessageKey.fromJson(event.item2.documentID,
                event.item2.data as LinkedHashMap<dynamic, dynamic>),
            event.item1.uid);
      else
        return null;
    });
  }

  @override
  Stream<List<Message>> getMessage(ThreadKey threads) {
    return currentUser()
        .flatMap((FirebaseUser user) =>
        Stream.fromFuture(_firestore
            .collection("threads")
            .document(threads.key)
            .collection("messages")
            .getDocuments())
            .map((QuerySnapshot snapshot) => snapshot.documents)
            .map((event) => Tuple2(user, event)))
        .flatMap((Tuple2<FirebaseUser, List<DocumentSnapshot>> tuple2) {
      if (tuple2.item2 == null) {
        return Stream.value(<Message>[]);
      } else {
        return Stream.value(tuple2.item2)
            .expand((element) => element)
            .map((event) {
          print(
              FbMessageKey.fromJson(event.documentID, event.data).toJson());
          return FbMessageKey.fromJson(event.documentID, event.data);
        })
            .map((FbMessageKey fbMessage) =>
            Message.fromFbMessageKey(fbMessage, tuple2.item1.uid))
            .toList()
            .asStream();
      }
    });
  }
}
