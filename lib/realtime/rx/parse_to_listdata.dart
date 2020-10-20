import 'dart:async';
import 'dart:collection';

import 'package:fimber/fimber.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/realtime/model/DocumentChange.dart';
import 'package:flutter_chat_demo/realtime/model/ListData.dart';
import 'package:optional/optional.dart';
import 'package:optional/optional_internal.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/transformers.dart';

extension ValidationExtension on Stream<Optional<DocumentChange>> {
  Stream<ListData> parseToListOfListData() {
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
  }

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

extension ValidationExtension1 on Stream<DocumentChange> {
  Stream<ListData> parseToListData() {
    return this.flatMap(
        (value) => Stream.value(value.snapshot).map((DataSnapshot snapshot) {
              Fimber.e("Snapshot  ${snapshot.key}" "${snapshot.value}");
              return ListData(snapshot.key, snapshot.value);
            }));
  }

  Stream<ListData> parseToListOfListData() {
    return this.map((event) {
      return event.snapshot;
    }).flatMap((value) {
      Fimber.e("Snapshot  ${value.key}" "${value.value}");
      if (value.value != null) {
        return Stream.value(value)
            .map((DataSnapshot snapshot) {
              Fimber.e("Snapshot  ${snapshot.key}" "${snapshot.value}");
              return (snapshot.value as LinkedHashMap<dynamic, dynamic>)
                  .entries;
            })
            .expand((element) {
              return element;
            })
            .map((event) {
              Fimber.e("ListData  ${event.key}" "${event.value}");
              return ListData(event.key, event.value);
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
