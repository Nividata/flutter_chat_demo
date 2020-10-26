import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_demo/realtime/model/DocumentChange1.dart';

class RxFirestore {
  Stream<DocumentSnapshot> on(DocumentReference ref) {
    return ref.snapshots();
  }

  Stream<DocumentChange2> onByQuery(Query ref) {
    return ref
            .snapshots()
            .map((event) => event.documentChanges)
            .expand((element) => element)
            .map((res) {
      // ignore: missing_return
      if (res.type == DocumentChangeType.added) {
        return DocumentChange2(res.document, type: EventType.Added);
      } else if (res.type == DocumentChangeType.modified) {
        return DocumentChange2(res.document, type: EventType.Removed);
      } else if (res.type == DocumentChangeType.removed) {
        return DocumentChange2(res.document, type: EventType.Modified);
      }
    })
        /*.map((event) => event.documentChanges)
        .expand((element) => element)*/
        ;
  }

  Stream<void> add(CollectionReference ref, dynamic data) {
    return Stream.fromFuture(ref.add(data));
  }

  Stream<void> set(DocumentReference ref, dynamic data) {
    return Stream.fromFuture(ref.setData(data));
  }

  Stream<void> delete(DocumentReference ref) {
    return Stream.fromFuture(ref.delete());
  }

  Stream<DocumentSnapshot> get(DocumentReference ref) {
    return Stream.fromFuture(ref.get());
  }

  Stream<QuerySnapshot> getByQuery(Query query) {
    return Stream.fromFuture(query.getDocuments());
  }
}
