import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/realtime/model/DocumentChange1.dart';
import 'package:rxdart/rxdart.dart';

class RXRealtime {
  Stream<DocumentChange1> on(Query query) {
    return query.onValue.map((event) => DocumentChange1(event.snapshot));
  }

  Stream<DocumentChange1> childOn(Query query) {
    return MergeStream([
      query.onChildAdded.map(
          (event) => DocumentChange1(event.snapshot, type: EventType.Added)),
      query.onChildRemoved.map(
          (event) => DocumentChange1(event.snapshot, type: EventType.Removed)),
      query.onChildChanged.map(
          (event) => DocumentChange1(event.snapshot, type: EventType.Modified))
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

  Stream<DocumentChange1> get(Query query) {
    return Stream.fromFuture(query.once()).map((event) {
      return DocumentChange1(event);
    });
  }
}
