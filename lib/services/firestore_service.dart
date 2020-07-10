import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/models/response/Message.dart';
import 'package:flutter_chat_demo/models/response/Threads.dart';
import 'package:flutter_chat_demo/services/authentication_service.dart';
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
    print("ok im here");
    return Stream.fromFuture(_authenticationService.currentUser()).transform(
        FlatMapStreamTransformer((FirebaseUser user) =>
            Stream.fromFuture(
                _firebaseDatabase
                    .reference()
                    .child("users")
                    .child(user.uid)
                    .update(data))));
  }

  Stream<String> createMessageThread(String name) {
    return Stream.fromFuture(_authenticationService.currentUser())
        .transform(FlatMapStreamTransformer((FirebaseUser user) =>
        Stream.value(
            Tuple2(
                user.uid,
                _firebaseDatabase
                    .reference()
                    .child("users")
                    .child(user.uid)
                    .child("message")
                    .push()
                    .key))))
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
              .child("threads")
              .child(tuple2.item2)
              .update(
              Threads(name: name, type: "oneToOne", owner: tuple2.item1)
                  .toJson())),
        ], (List<void> b) => b.length.toString()));
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
          print(event.keys.toList());
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
                (snapshot.value as LinkedHashMap<dynamic, dynamic>).keys.first,
                (snapshot.value as LinkedHashMap<dynamic, dynamic>)
                    .values
                    .first)))
        .toList()
        .asStream();
  }

  Stream<void> sendMessage(Threads threads, Message message) {
    return Stream.fromFuture(_authenticationService.currentUser()).flatMap((
        value) =>
        Stream.fromFuture(_firebaseDatabase
            .reference()
            .child("threads")
            .child(threads.key)
            .child("messages")
            .push().set(message.toJson())
        ));
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
          print(Message.fromJson(event).toJson());
          return Message.fromJson(event);
        })
            .toList().asStream();
      }
    }

    );
  }
}
