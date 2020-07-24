import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/models/DocumentChange.dart';
import 'package:optional/optional.dart';
import 'package:rxdart/rxdart.dart';

class RXRealtime {
  Stream<DocumentChange> on(Query query) {
    return query.onValue.map((event) => DocumentChange(event.snapshot));
  }

  Stream<DocumentChange> childOn(Query query) {
    return MergeStream([
      query.onChildAdded.map(
          (event) => DocumentChange(event.snapshot, type: EventType.Added)),
      query.onChildRemoved.map(
          (event) => DocumentChange(event.snapshot, type: EventType.Removed)),
      query.onChildChanged.map(
          (event) => DocumentChange(event.snapshot, type: EventType.Modified))
    ]);
  }

  Stream<void> add(DatabaseReference ref, dynamic data, {dynamic priority}) {
    if (priority == null) {
      return Stream.fromFuture(ref.set(data));
    } else {
      return Stream.fromFuture(ref.set(data, priority: priority));
    }
  }

  Stream<void> delete(DatabaseReference ref) {
    return Stream.fromFuture(ref.remove());
  }

  Stream<DocumentChange> get(Query query) {
    return Stream.fromFuture(query.once()).map((event) {
      return DocumentChange(event);
    });
  }
}
