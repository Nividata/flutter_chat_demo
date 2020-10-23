import 'package:cloud_firestore/cloud_firestore.dart';

class RxFirestore {
  Stream<DocumentSnapshot> on(DocumentReference ref) {
    return ref.snapshots();
  }

  Stream<DocumentChange> onByQuery(Query ref) {
    return ref
        .snapshots()
        .map((event) => event.documentChanges)
        .expand((element) => element);
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
