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

  Stream<String> add(DatabaseReference ref, dynamic data, {dynamic priority}) {
    DatabaseReference childRef = ref.push();
    String id = childRef.key;
    if (priority == null) {
      return Stream.fromFuture(childRef.set(data)).map((event) => id);
    } else {
      return Stream.fromFuture(childRef.set(data, priority: priority))
          .map((event) => id);
    }
  }

  Stream<void> delete(DatabaseReference ref) {
    return Stream.fromFuture(ref.remove());
  }

  Stream<Optional<DocumentChange>> get(Query query) {
    return Stream.fromFuture(query.once()).map((event) {
      return DocumentChange(event).toOptional;
    });
  }
}
