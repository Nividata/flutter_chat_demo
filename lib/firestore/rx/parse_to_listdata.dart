import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/realtime/model/DocumentChange.dart';
import 'package:flutter_chat_demo/realtime/model/ListData.dart';
import 'package:optional/optional.dart';
import 'package:optional/optional_internal.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/transformers.dart';

extension ValidationExtension on Stream<Optional<QuerySnapshot>> {
  /* Stream<ListData> parseToListOfListData() {
    return this
        .map((event) {
          return event.value.snapshot;
        })
        .flatMap((value) => Stream.value(value)
            .map((DataSnapshot snapshot) {
              Fimber.e("Snapshot  ${snapshot.key}" "${snapshot.value}");
              return (snapshot.value as LinkedHashMap<dynamic, dynamic>)
                  .entries;
            })
            .expand((element) {
              print(element.runtimeType);
              return element;
            })
            .map((event) {
              Fimber.e("ListData  ${event.key}" "${event.value}");
              return ListData(event.key, event.value);
            })
            .toList()
            .asStream())
        .expand((element) => element);
  }*/

/*Stream<ListData> parseToListData() {
    return this.map((event) {
      return event.value.snapshot;
    }).map((DataSnapshot snapshot) {
      print(snapshot.runtimeType);
      print(snapshot.value);
      print(snapshot.key);
      return (snapshot.value as LinkedHashMap<dynamic, dynamic>).entries;
    }).map((event) {
      print("UserKey  ${event.key}" "${event.value}");
      return ListData(event.key, event.value);
    });
  }*/
}

extension ValidationExtension2 on Stream<DocumentSnapshot> {
  Stream<ListData> parseToListData() {
    return this.flatMap((value) =>
        Stream.value(value).map((DocumentSnapshot snapshot) {
          Fimber.e(
              "DocumentSnapshot  ${snapshot.documentID}" "${snapshot.data}");
          return ListData(snapshot.documentID, snapshot.data);
        }));
  }
}

extension ValidationExtension1 on Stream<QuerySnapshot> {
  Stream<ListData> parseToListOfListData() {
    return this.map((QuerySnapshot snapshot) {
      return snapshot.documents;
    }).flatMap((value) {
      Fimber.e("QuerySnapshot  ${value.length}");
      if (value.isNotEmpty) {
        return Stream.value(value)
            .expand((element) => element)
            .map((event) {
              Fimber.e("ListData  ${event.documentID}" "${event.data}");
              return ListData(event.documentID, event.data);
            })
            .toList()
            .asStream()
            .map((event) => event);
      } else {
        return Stream.value(List<ListData>());
      }
    }).map((event) {
      Fimber.e("${event.toString()}");
      return event;
    }).expand((element) => element);
  }
}
